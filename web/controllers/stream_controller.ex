defmodule Streamr.StreamController do
  use Streamr.Web, :controller
  alias Streamr.{Stream, Repo}

  def index(conn, params) do
    streams = Stream
    |> Stream.with_users
    |> Stream.ordered
    |> Repo.paginate(params)

    render(conn, "index.json-api", data: streams)
  end

  def create(conn, %{"stream" => stream_params}) do
    changeset = Guardian.Plug.current_resource(conn)
                |> Ecto.build_assoc(:streams)
                |> Stream.changeset(stream_params)

    case Repo.insert(changeset) do
      {:ok, stream} ->
        conn
        |> put_status(201)
        |> render("show.json-api", data: Repo.preload(stream, :user))
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render("errors.json-api", data: changeset)
    end
  end
end
