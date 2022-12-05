defmodule TodolistApiWeb.ForgetPasswordView do
  use TodolistApiWeb, :view

  def render("send.json", %{message: message, token: token, expire: expire}) do
    %{
      message: message,
      data: %{
        "token": token,
        "expire": expire
      }
    }
  end

  def render("check.json", %{message: message, check: check}) do
    %{
      message: message,
      data: %{
        "check": check
      }
    }
  end
  def render("reset.json", _params) do
    %{
      message: "Password reset successfully",
      data: nil
    }
  end
end
