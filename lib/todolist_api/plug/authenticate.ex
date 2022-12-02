defmodule TodolistApi.Plug.Authenticate do
  import Plug.Conn
  alias TodoistApi.Users

  def init(options) do
    options
  end

  def call(conn, _options) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok , user } <- Users.verify_token(token) do
        conn
        |> assign(:current_user,user)
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.json(%{
            message: "Token is invalid"
          })
        |> halt()
    end
  end
end
