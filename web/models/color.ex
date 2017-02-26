defmodule Streamr.Color do
  use Streamr.Web, :model

  schema "colors" do
    field :normal, :string
    field :deuteranopia, :string
    field :protanopia, :string
    field :tritanopia, :string

    timestamps
  end
end
