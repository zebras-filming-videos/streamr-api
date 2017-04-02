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

      assert response
              |> Enum.map(&(&1["relationships"]["stream"]["data"]["id"]))
              |> Enum.all?(&(stream.id == String.to_integer(&1)))

      assert 3 == Enum.count(response)
    end
  end

  describe "POST /api/v1/comments" do
    test "it creates a new comment" do
    end
  end

  describe "DELETE /api/v1/comments/:id" do
    test "it deletes the stream" do
    end
  end
end
