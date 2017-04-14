defmodule Streamr.PasswordResetToken do
  use Streamr.Web, :controller

  alias Streamr.{Repo, User, PasswordResetMailer}

  def generate(conn, %{"email" => email}) do

  end
end
