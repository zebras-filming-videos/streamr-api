defmodule Streamr.CommentTest do
  use Streamr.ConnCase
  alias Streamr.{Repo, Comment}

  import Streamr.Factory

  describe ".ordered" do
    test "returns newest comments first" do
      stream = insert(:stream)
      oldest = build(:comment, stream: stream, inserted_at: days_ago(5)) |> insert
      newest = build(:comment, stream: stream, inserted_at: days_ago(0)) |> insert
      middle = build(:comment, stream: stream, inserted_at: days_ago(3)) |> insert

      comment_ids = stream.id
                    |> Comment.for_stream()
                    |> Comment.ordered()
                    |> Repo.all()
                    |> Enum.map(&(&1.id))

      assert comment_ids == [newest.id, middle.id, oldest.id]
    end
  end

  defp days_ago(offset) do
    Timex.now() |> Timex.shift(days: -1 * offset)
  end
end
