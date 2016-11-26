defmodule Streamr.RefreshTokenTest do
  use Streamr.ConnCase

  alias Streamr.{RefreshToken, Repo}
  import Streamr.Factory

  describe ".find_and_confirm_password" do
    setup do
      [user: insert(:user)]
    end

    test "returns the user, if credentials are valid", context do
      {:ok, refresh_token} = RefreshToken.create_for_user(context[:user])

      assert refresh_token
      assert refresh_token.user_id == context[:user].id
    end

    test "it deletes the oldest token if the user has more than 20", context do
      old_token = insert(:refresh_token, user: context[:user])
      insert_list(19, :refresh_token, user: context[:user])

      {:ok, _} = RefreshToken.create_for_user(context[:user])

      assert RefreshToken.user_token_count(context[:user]) == 20
      refute Repo.get(RefreshToken, old_token.id)
    end
  end
end
