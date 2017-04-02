defmodule Streamr.Comment do
  use Streamr.Web, :model
  use Timex.Ecto.Timestamps
  alias Streamr.Repo

  schema "comments" do
    belongs_to :stream, Streamr.Stream

    field :body, :string, null: false

    timestamps()
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, [:body])
    |> validate_required([:body])
  end

  def with_streams(query) do
    from comment in query,
    preload: [:stream],
    select: comment
  end

  def ordered(query) do
    from comment in query,
    order_by: [asc: comment.id]
  end

  def for_stream(stream_id) do
    from comment in Streamr.Comment,
      where: comment.stream_id == ^stream_id
  end
end
