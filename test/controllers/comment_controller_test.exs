defmodule Streamr.CommentControllerTest do
  use Streamr.ConnCase

  import Streamr.Factory

  alias Streamr.{Repo, Comment, Stream}

  describe "GET /api/v1/streams/:stream_id/comments" do
    test "get a stream's comments" do
      stream = insert(:stream)
      insert_list(3, :comment, stream: stream)
      insert_list(2, :comment)

      conn = get(
        build_conn(),
        "/api/v1/streams/#{stream.id}/comments"
      )

      response = json_response(conn, 200)["data"]
      assert 3 == Enum.count(response)
    end
  end

  describe "POST /api/v1/streams/:stream_id/comments" do
    test "it creates a new comment" do
      stream = insert(:stream)
      user = insert(:user)

      conn = post_authorized(
        user,
        "/api/v1/streams/#{stream.id}/comments",
        %{comment: %{body: "test body"}}
      )

      response = json_response(conn, 201)["data"]

      assert response["attributes"]["body"] == "test body"
    end

    test "it prevents commenting unless the user is signed in" do
      stream = insert(:stream)
      user = insert(:user)

      conn = post(
        build_conn(),
        "/api/v1/streams/#{stream.id}/comments",
        %{comment: %{body: "test body"}}
      )

      response = json_response(conn, 401)
    end
  end

  describe "DELETE /api/v1/comments/:id" do
    test "it deletes the stream" do
    end
  end
end
