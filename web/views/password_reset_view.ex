defmodule Streamr.PasswordResetView do
  use Streamr.Web, :view

  def render("invalid_token.json", _assigns) do
    %{errors: [%{
        title: "invalid token",
        detail: "Password reset token has expired",
        status: 401
        }]}
  end
end
