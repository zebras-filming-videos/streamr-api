defmodule Streamr.ColorView do
  use Streamr.Web, :view
  use JaSerializer.PhoenixView

  attributes [:hex]

  def hex(color, %{assigns: %{current_user: nil}}), do: color.normal
  def hex(color, %{assigns: %{current_user: user}}), do: Map.get(color, user.color_preference)
end
