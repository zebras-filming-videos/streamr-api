defmodule Streamr.StreamController do
  use Streamr.Web, :controller
  alias Streamr.{Stream, Repo, StreamData}

  plug Streamr.Authenticate when action in [:create, :add_line]

  def index(conn, params) do
    streams = Stream
    |> Stream.with_users
    |> Stream.ordered
    |> Repo.paginate(params)

    render(conn, "index.json-api", data: streams)
  end

  def create(conn, %{"stream" => stream_params}) do
    changeset = conn
                |> Guardian.Plug.current_resource
                |> Ecto.build_assoc(:streams)
                |> Stream.changeset(stream_params)

    case Repo.insert(changeset) do
      {:ok, stream} ->
        StreamData.initialize_for(stream)

        conn
        |> put_status(201)
        |> render("show.json-api", data: Repo.preload(stream, :user))
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render("errors.json-api", data: changeset)
    end
  end

  def add_line(conn, params) do
    stream = get_stream(params)

    case StreamData.append_to(stream, params["line"]) do
      {:ok, _} ->
        send_resp(conn, 201, "")
      {:error, err} ->
        IO.puts err
        send_resp(conn, 422, "")
    end
  end

  defp get_stream(params) do
    Repo.get(Stream, Map.get(params, "stream_id"))
  end
end
