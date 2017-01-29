defmodule Streamr.Stream do
  use Streamr.Web, :model

  schema "streams" do
    belongs_to :user, Streamr.User
    field :title, :string, null: false
    field :description, :string
    field :image, :string

    timestamps
  end
end
