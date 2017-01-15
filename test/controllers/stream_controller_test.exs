defmodule Streamr.StreamControllerTest do
  use Streamr.ConnCase

  import Streamr.Factory

  describe "GET /api/v1/streams" do
    setup do
      user = insert(:user)
      insert_list(2, :stream)

      conn = build_conn()
             |> Guardian.Plug.api_sign_in(user)

      {:ok, [conn: conn]}
    end

    test "it returns all streams", %{conn: conn} do
      conn = get(
        conn,
        "/api/v1/streams"
      )

      response = json_response(conn, 200)["data"]

      assert 2 == Enum.count(response)
    end
  end
end
