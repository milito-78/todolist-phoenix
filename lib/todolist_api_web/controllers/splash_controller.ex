defmodule TodolistApiWeb.SplashController do
  use TodolistApiWeb, :controller

  alias TodolistApi.Options

  action_fallback TodolistApiWeb.FallbackController

  def show(conn, _params) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization") do
      conn
      |> render("show.json",options: Options.splash(token))
    else
      _ ->  conn
            |> render("show.json",options: Options.splash(nil))
    end


  end
end
