defmodule Streamr.CommentController do
  use Streamr.Web, :controller

  alias Streamr.{Comment, Repo, Stream}

  plug Streamr.Authenticate when action in [:create, :delete]

  def index(conn, params) do
    comments = params["stream_id"]
               |> filtered_comments
               |> Comment.with_streams
               |> Comment.ordered
               |> Repo.paginate(params)

    render(conn, "index.json-api", data: comments)
  end

  defp filtered_comments(stream_id) do
    if stream_id do
      Comment.for_stream(stream_id)
    else
      Comment
    end
  end
end
