defmodule Streamr.Email do
  import Swoosh.Email
  # When we want to do HTML
  # use view: Streamr.EmailView

  def welcome_email(user) do
    new
    |> to({user.name, user.email})
    |> from({"Team Streamr", "team@streamr.live"})
    |> subject("Welcome to Streamr")
    |> text_body("Just verify with us.")
  end
end
