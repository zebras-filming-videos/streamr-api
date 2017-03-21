defmodule Streamr.Router do
  use Streamr.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/api/v1", Streamr do
    pipe_through :api

    post "/users/auth", UserController, :auth
    get "/users/email_available", UserController, :email_available
    get "/users/me", UserController, :me
    resources "/users", UserController, only: [:create, :show] do
      resources "/streams", StreamController, only: [:index]
    end

    resources "/streams", StreamController do
      post "/add_line", StreamController, :add_line
      post "/end", StreamController, :end_stream
    end

    resources "/topics", TopicController, only: [:index]

    resources "/colors", ColorController, only: [:index]
  end
end
