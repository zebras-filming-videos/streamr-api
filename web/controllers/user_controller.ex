defmodule Streamr.UserController do
  use Streamr.Web, :controller
  alias Streamr.User

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(201)
        |> render("show.json", user: user)
    end
  end
end
