defmodule TodolistApiWeb.ForgetPasswordController do
  use TodolistApiWeb, :controller

  alias TodolistApi.ForgetPasswords
  alias TodolistApi.ForgetPasswords.ForgetPassword

  action_fallback TodolistApiWeb.FallbackController

  def forget_password(conn, %{"email" => email}) do
    with {:ok, %ForgetPassword{} = forget} <- ForgetPasswords.forget_password(email) do
      conn
      |> put_status(202)
      |> render("send.json",%{message: "Verify code has been sent successfully" , token: forget.token, expire: forget.expire})
    else
      {:error,:undefined} ->
          conn
          |> put_status(:unprocessable_entity)
          |> json(%{
              message: "Validation Exception",
              errors: %{
                "email" => [
                  "email is not exists"
                ]
              }
            })
      {:error,%ForgetPassword{} = forget} ->
          conn
          |> render("send.json",%{message: "Verify code has been sent you before" , token: forget.token, expire: forget.expire})
    end
  end

  def check_code(conn, _params) do
    data = conn.query_params
    with true <- check_email_token(data),
        { :ok, :true, _, _ } <- ForgetPasswords.check_code(data["email"],data["token"],data["code"]) do
      conn
      |> render("check.json",%{message: "code is valid" , check: true})
    else
      false -> conn |> render("check.json",%{message: "code is valid" , check: true})
      {:error,:undefined} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
            message: "Validation Exception",
            errors: %{
              "email" => [
                "email is not exists"
              ]
            }
          })
      {:error, :false} ->
        conn
        |> render("check.json",%{message: "code is invalid" ,check: false})
    end

  end

  def reset_password(conn, %{"code" => code,"email" => email, "token" => token,"password" => password, "password_confirmation" => password_confirmation }) do
    with { :ok, _ } <- ForgetPasswords.reset_password(code, email, token, password) do
      conn
      |> render("reset.json")
    else
      {:error,:undefined} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
            message: "Validation Exception",
            errors: %{
              "email" => [
                "email is not exists"
              ]
            }
          })
      {:error, :false} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
            message: "Validation Exception",
            errors: %{
              "code" => [
                "Please verify you account once more. Verify code has been expired"
              ]
            }
          })
      _ ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
            message: "Validation Exception",
            errors: %{
              "code" => [
                "yes"
              ]
            }
          })
    end
  end


  defp check_email_token(data) do
    Map.has_key?(data, "email") && Map.has_key?(data, "token") &&  Map.has_key?(data, "code")
  end

end
