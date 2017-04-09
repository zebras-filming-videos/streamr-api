defmodule Streamr.VoteController do
  use Streamr.Web, :controller

  alias Streamr.{Vote, Repo}

  plug Streamr.Authenticate
  plug :find_vote when action in [:delete]

  def create(conn, params) do
    case Repo.transaction(Streamr.VoteManager.create(conn.assigns.current_user, params)) do
      {:ok, _vote} -> send_resp(conn, 204, "")
      {:error, _, errors, _} ->
        conn
        |> put_status(422)
        |> render("errors.json-api", data: errors)
    end
  end

  def delete(conn, params) do
    case Repo.transaction(Streamr.VoteManager.delete(conn.assigns.current_user, params)) do
      {:ok, _} -> send_resp(conn, 204, "")
      {:error, _, errors, _} ->
        conn
        |> put_status(422)
        |> render("errors.json-api", data: errors)
    end
  end

  def find_vote(conn, _) do
    resource = get_resource(conn, conn.assigns.current_user)

    if is_nil(resource) do
      conn |> put_status(422) |> render("missing_vote.json") |> halt
    else
      Plug.Conn.assign(conn, :vote, get_resource(conn, conn.assigns.current_user))
    end
  end

  def get_resource(%Plug.Conn{params: %{"stream_id" => stream_id}}, user) do
    Repo.get_by(
      Streamr.Vote,
      stream_id: stream_id,
      user_id: user.id
    )
  end

  def get_resource(%Plug.Conn{params: %{"comment_id" => comment_id}}, user) do
    Repo.get_by(
      Streamr.Vote,
      comment_id: comment_id,
      user_id: user.id
    )
  end
end
