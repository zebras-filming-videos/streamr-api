defmodule Streamr.VoteManager do
  alias Ecto.Multi
  alias Streamr.{Vote, Comment, Stream, Repo}

  def create(user, params) do
    Multi.new
    |> Multi.insert(:vote, vote_changeset(user, params))
    |> Multi.update(:voteable, vote_quantity_changeset(params, :increment))
  end

  def delete(user, params) do
    Multi.new
    |> Multi.delete(:vote, get_vote(user, params))
    |> Multi.update(:voteable, vote_quantity_changeset(params, :decrement))
  end

  defp vote_changeset(user, params) do
    user |> Ecto.build_assoc(:votes) |> Vote.changeset(params)
  end

  defp get_vote(user, %{"comment_id" => comment_id}) do
    Repo.get_by!(Vote, comment_id: comment_id, user_id: user.id)
  end

  defp get_vote(user, %{"stream_id" => stream_id}) do
    Repo.get_by!(Vote, stream_id: stream_id, user_id: user.id)
  end

  defp vote_quantity_changeset(%{"comment_id" => comment_id}, quantity) do
    Comment
    |> Repo.get!(comment_id)
    |> Comment.change_votes_count_changeset(quantity)
  end

  defp vote_quantity_changeset(%{"stream_id" => stream_id}, quantity) do
    Stream
    |> Repo.get!(stream_id)
    |> Stream.change_votes_count_changeset(quantity)
  end
end
