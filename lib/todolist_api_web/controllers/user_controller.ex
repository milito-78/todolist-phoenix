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
    conn
    |> render("show.json",user: conn.assigns[:current_user])

  end

  def logout(conn, _params) do
    ["Bearer " <> token] = get_req_header(conn, "authorization")
    with {:ok } <- Users.revoke(token) do
      send_resp(conn, :no_content, "")
    end
  end

  def change_password(conn, %{"current_password" => current, "password" => password, "password_confirmation" => confirmation }) do

    with {:ok, _} <- Users.change_current_password( conn.assigns[:current_user],current,password,confirmation) do
      send_resp(conn, :no_content, "")
    else
      {:error, :current_password} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
            message: "Validation Exception",
            errors: %{
              "current_password" => [
                "Your current password is incorrect"
              ]
            }
          })
      {:error, :confirmation} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
            message: "Validation Exception",
            errors: %{
              "password" => [
                "password confirmation is incorrect"
              ]
            }
          })
        _ ->
          conn
          |> put_status(:server_error)
          |> json(%{
              message: "Server Error",
              errors: "There is an error during update password"
            })
    end

  end
end
