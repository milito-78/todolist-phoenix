defmodule TodolistApiWeb.UserController do
  use TodolistApiWeb, :controller

  alias TodolistApi.Users

  action_fallback TodolistApiWeb.FallbackController

  def login(conn,  %{"email" => email, "password" => password}) do
    case Users.authenticate(email , password) do
      {:ok, token, user} -> conn
          |> render("login.json", user: user,token: token)
      {:error, :unauthenticated} -> conn
          |> put_status(:unprocessable_entity)
          |> json(%{
              message: "Validation Exception",
              errors: %{
                "email" => [
                  "Email or password is incorrect"
                ]
              }
            })
    end
  end

  def register(conn, user_params) do
    with {:ok, token, user} <- Users.register(user_params) do
      conn
      |> put_status(:created)
      |> render("register.json", user: user, token: token)
    end
  end

  def profile(conn, _params) do
    # Cachex.put(:my_cache, "Test", "This is a test",ttl: :timer.seconds(5))
    # IO.inspect(Cachex.get(:my_cache, "XXX"))
    # IO.inspect(Cachex.get(:my_cache, "Test"))

    conn
    |> render("show.json",user: conn.assigns[:current_user])

  end

  def logout(conn, _params) do
    ["Bearer " <> token] = get_req_header(conn, "authorization")
    with {:ok } <- Users.revoke(token) do
      send_resp(conn, :no_content, "")
    end
  end
end
