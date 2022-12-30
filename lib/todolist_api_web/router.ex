defmodule TodolistApiWeb.Router do
  use TodolistApiWeb, :router

  pipeline :api do
    plug :accepts, ["json","multipart/form-data"]
  end

  pipeline :authenticated do
    plug TodolistApi.Plug.Authenticate
  end

  scope "/api", TodolistApiWeb do
    pipe_through :api
    scope "/user" do
      post "/login", UserController, :login
      post "/register", UserController, :register

      scope "/forgot-password" do
        post "/send-code", ForgetPasswordController, :forget_password
        get "/check-code", ForgetPasswordController, :check_code
        post "/reset-password", ForgetPasswordController, :reset_password
      end
    end
    get "/splash", SplashController, :show
  end

  scope "/api", TodolistApiWeb do
    pipe_through [:api, :authenticated]
    scope "/user" do
      get "/profile", UserController, :profile
      patch "/change-password", UserController, :change_password
      post "/logout", UserController, :logout

      scope "/tasks" do
        get "/", TaskController, :index
        post "/", TaskController, :create
        get "/:id", TaskController, :show
        patch "/:id", TaskController, :update
        delete "/:id", TaskController, :delete
      end
    end

    post "/uploader", UploadController, :create
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TodolistApiWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
