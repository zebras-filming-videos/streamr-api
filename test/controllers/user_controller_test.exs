defmodule Streamr.UserControllerTest do
  use Streamr.ConnCase

  @valid_user_attrs %{name: "Foo Bar", username: "foosername", password: "password"}

  test "POST /users/new", %{conn: conn} do
    conn = post conn, "/users/new", %{"user" => @valid_user_attrs}
    body = json_response(conn, 201)

    assert body["data"]["id"]
    assert body["data"]["attributes"]["username"] == "foosername"
    assert body["data"]["attributes"]["name"] == "Foo Bar"
    refute body["data"]["attributes"]["password"]
    refute body["data"]["attributes"]["password_hash"]
  end
end
