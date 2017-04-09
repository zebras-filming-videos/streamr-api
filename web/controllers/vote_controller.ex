defmodule Streamr.VoteController do
  use Streamr.Web, :controller

  alias Streamr.{Vote, Repo}

  plug Streamr.Authenticate when action in [:create]

  def create(conn, params) do
    changeset = conn.assigns[:current_user] |> Ecto.build_assoc(:votes) |> Vote.changeset(params)

    case Repo.insert(changeset) do
      {:ok, _vote} -> send_resp(conn, 204, "")
      {:error, errors} ->
        conn
        |> put_status(422)
        |> render("errors.json-api", data: errors)
    end
  end
end
