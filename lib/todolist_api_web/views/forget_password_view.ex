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
end
