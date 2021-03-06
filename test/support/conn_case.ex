defmodule Streamr.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias Streamr.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import Streamr.Router.Helpers

      # The default endpoint for testing
      @endpoint Streamr.Endpoint

      def post_authorized(user, endpoint, body \\ %{}) do
        build_conn()
        |> Guardian.Plug.api_sign_in(user)
        |> post(endpoint, body)
      end

      def put_authorized(user, endpoint, body \\ %{}) do
        build_conn()
        |> Guardian.Plug.api_sign_in(user)
        |> put(endpoint, body)
      end

      def delete_authorized(user, endpoint, body \\ %{}) do
        build_conn()
        |> Guardian.Plug.api_sign_in(user)
        |> delete(endpoint, body)
      end

      def get_authorized(user, endpoint, body \\ %{}) do
        build_conn()
        |> Guardian.Plug.api_sign_in(user)
        |> get(endpoint, body)
      end

      def response_ids(response) do
        response
        |> extract_ids_from_json()
        |> Enum.sort()
      end

      def model_ids(db_rows) do
        db_rows
        |> Enum.map(fn(object) -> object.id end)
        |> Enum.sort()
      end

      def extract_ids_from_json(response) do
        response
        |> Map.get("data")
        |> Enum.map(fn(object) -> String.to_integer(object["id"]) end)
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Streamr.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Streamr.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
