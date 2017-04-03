defmodule Streamr.CommentController do
  use Streamr.Web, :controller

  alias Streamr.{Comment, Repo, Stream}

  plug Streamr.Authenticate when action in [:create, :delete]

  def index(conn, params) do
    comments = params["stream_id"]
               |> Comment.for_stream
               |> Comment.with_users
               |> Comment.ordered
               |> Repo.paginate(params)

    render(conn, "index.json-api", data: comments)
  end

  def create(conn, %{"stream_id" => stream_id, "comment" => comment_params}) do
    changeset = conn
                |> build_comment(stream_id)
                |> Comment.changeset(comment_params)

    case Repo.insert(changeset) do
      {:ok, comment} ->
        conn
        |> put_status(201)
        |> render("show.json-api", data: Repo.preload(comment, :user))

      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render("errors.json-api", data: changeset)
    end
  end

  defp build_comment(conn, stream_id) do
    %Comment{
      stream_id: String.to_integer(stream_id),
      user_id: Guardian.Plug.current_resource(conn).id
    }
  end
end
