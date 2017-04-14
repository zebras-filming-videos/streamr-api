defmodule Streamr.PasswordResetEmail do
  use Phoenix.Swoosh, view: Streamr.Email.PasswordResetView, layout: {Streamr.LayoutView, :email}

  alias Streamr.{Repo, User, PasswordResetToken}

  @frontend_password_reset_url Application.get_env(:streamr, :frontend_password_reset_url)

  def reset_password(email) do
    user = Repo.get_by!(User, email: email)
    token = PasswordResetToken.generate(user)
    url = @frontend_password_reset_url <> "?token=#{token}"

    new()
    |> to({user.name, user.email})
    |> from({"Team Streamr", "team@streamr.live"})
    |> subject("Streamr Password Reset")
    |> render_body("password_reset.html" , %{name: user.name, url: url})
  end
end
