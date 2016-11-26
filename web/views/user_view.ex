defmodule Streamr.UserView do
  use Streamr.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :email]

  def render("invalid_login.json", _assigns) do
    %{errors: [%{
        title: "invalid login",
        detail: "Invalid username/password combination",
        status: 401}]}
  end

  def render("refresh_token.json", %{access_token: access_token, refresh_token: refresh_token}) do
    %{
      access_token: access_token,
      token_type: "bearer",
      expires_in: 3600,
      refresh_token: refresh_token.token
    }
  end
end
