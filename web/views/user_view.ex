defmodule Streamr.UserView do
  use Streamr.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :username]
end
