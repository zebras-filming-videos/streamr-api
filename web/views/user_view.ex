defmodule Streamr.UserView do
  use Streamr.Web, :view

  def render("show.json", %{user: user}) do
    JaSerializer.format(Streamr.UserSerializer, user)
  end
end
