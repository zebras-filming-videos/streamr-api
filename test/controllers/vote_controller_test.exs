defmodule Streamr.VoteControllerTest do
  use Streamr.ConnCase
  import Streamr.Factory

  describe "POST /api/v1/streams/:id/votes" do
    test "it creates a new vote for the stream from the user" do
      stream = insert(:stream)
      user = insert(:user)

      conn = post_authorized(user, "/api/v1/streams/#{stream.id}/votes")

      assert conn.status == 204
      assert Streamr.Vote.count(stream) == 1
    end

    test "it does not create duplicate votes for the same user" do
      stream = insert(:stream)
      user = insert(:user)
      insert(:vote, stream: stream, user: user)

      conn = post_authorized(user, "/api/v1/streams/#{stream.id}/votes")

      json_response(conn, 422)
      assert Streamr.Vote.count(stream) == 1
    end

    test "it requires users to be signed in" do
      conn = post(build_conn(), "/api/v1/streams/#{insert(:stream).id}/votes")

      assert conn.status == 401
    end
  end

  describe "POST /api/v1/comments/:id/votes" do
    test "it creates a new vote for the comment from the user" do
      comment = insert(:comment)
      user = insert(:user)

      conn = post_authorized(user, "/api/v1/comments/#{comment.id}/votes")

      assert conn.status == 204
      assert Streamr.Vote.count(comment) == 1
    end

    test "it does not create duplicate votes for the same user" do
      comment = insert(:comment)
      user = insert(:user)
      insert(:vote, comment: comment, user: user)

      conn = post_authorized(user, "/api/v1/comments/#{comment.id}/votes")

      json_response(conn, 422)
      assert Streamr.Vote.count(comment) == 1
    end

    test "it requires users to be signed in" do
      conn = post(build_conn(), "/api/v1/comments/#{insert(:comment).id}/votes")

      assert conn.status == 401
    end
  end
end
