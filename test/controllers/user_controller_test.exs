defmodule Streamr.UserControllerTest do
  use Streamr.ConnCase

  @valid_user_attrs %{name: "Foo Bar", username: "foosername", password: "password"}
  @invalid_user_attrs %{name: "Foo Bar", username: nil, password: "password"}

  describe "POST /users/new" do
    test "with valid user data", %{conn: conn} do
      conn = post conn, "/users/new", %{"user" => @valid_user_attrs}
      body = json_response(conn, 201)

      assert body["data"]["id"]
      assert body["data"]["attributes"]["username"] == "foosername"
      assert body["data"]["attributes"]["name"] == "Foo Bar"
      refute body["data"]["attributes"]["password"]
      refute body["data"]["attributes"]["password_hash"]
    end

    test "with invalid data", %{conn: conn} do
      conn = post conn, "/users/new", %{"user" => @invalid_user_attrs}
      body = json_response(conn, 422)["errors"]
      assert body == [%{
        "detail" => "Username can't be blank",
        "title" => "can't be blank",
        "source" => %{"pointer" => "/data/attributes/username"}}]
    end
  end
end
