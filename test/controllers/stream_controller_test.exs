defmodule Streamr.StreamControllerTest do
  use Streamr.ConnCase

  import Streamr.Factory

  describe "GET /api/v1/streams" do
    setup do
      insert_list(2, :stream)

      :ok
    end

    test "it returns all streams" do
      conn = get(
        build_conn(),
        "/api/v1/streams"
      )

      response = json_response(conn, 200)["data"]

      assert 2 == Enum.count(response)
    end
  end

  describe "POST /api/v1/streams" do
    test "it creates a new stream" do
      user = insert(:user)
      valid_stream = params_for(:stream)

      conn = post_authorized(user, "/api/v1/streams", %{stream: valid_stream})
      body = json_response(conn, 201)

      assert body["data"]["id"]
      assert body["data"]["attributes"]["title"] == valid_stream.title
      assert body["data"]["attributes"]["description"] == valid_stream.description
      assert body["data"]["relationships"]["user"]["data"]["id"] == Integer.to_string(user.id)
    end
  end
end
