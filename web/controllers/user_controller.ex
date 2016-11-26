defmodule Streamr.UserController do
  use Streamr.Web, :controller
  alias Streamr.User

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(201)
        |> render("show.json-api", data: user)

      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render("errors.json-api", data: changeset)
    end
  end

  def auth(conn, %{"email" => email, "password" => password, "grant_type" => "password"}) do
    case User.find_and_confirm_password(email, password) do
      {:ok, user} ->
        new_conn = Guardian.Plug.api_sign_in(conn, user)
        jwt = Guardian.Plug.current_token(new_conn)
        {:ok, refresh_token} = Streamr.RefreshToken.create_for_user(user)

        new_conn
        |> render("refresh_token.json", access_token: jwt, refresh_token: refresh_token)

      {:error, _} ->
        conn
        |> put_status(401)
        |> render("invalid_login.json")
    end
  end

  def auth(conn, %{"refresh_token" => refresh_token, "grant_type" => "refresh_token"}) do
  end
end
