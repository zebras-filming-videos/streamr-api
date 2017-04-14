defmodule Streamr.PasswordResetControllerTest do
  use Streamr.ConnCase

  import Streamr.Factory

  alias Streamr.{PasswordResetToken, User, Repo}
  alias Comeonin.Bcrypt

  describe "POST /api/v1/password_reset" do
    test "it sends a password reset email to the user who requested it" do
      user = insert(:user)

      conn = post(build_conn(), "/api/v1/password_reset", %{email: user.email})

      assert conn.status == 204
    end

    test "it returns a 404 when the user does not exist" do
      conn = post(build_conn(), "/api/v1/password_reset", %{email: "INVALID"})

      assert conn.status == 404
    end
  end

  describe "PATCH /api/v1/password_reset" do
    test "it resets a user's password when given a valid token" do
      user = insert(:user)
      token = PasswordResetToken.generate(user)

      conn = put(build_conn(), "/api/v1/password_reset", %{token: token, password: "foobity"})

      assert conn.status == 204
    end

    test "it returns a 401 when the token has already been used" do
      user = insert(:user)
      token = PasswordResetToken.generate(user)

      # changing the user's password invalidates the token
      user |> User.registration_changeset(%{password: "new"}) |> Repo.update()

      conn = put(build_conn(), "/api/v1/password_reset", %{token: token, password: "foobity"})

      assert conn.status == 204
      assert Bcrypt.checkpw("new", user.password_hash)
    end
  end
end
