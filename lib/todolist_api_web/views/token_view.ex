defmodule TodolistApiWeb.TokenView do
  use TodolistApiWeb, :view

  def render("token.json", %{token: token}) do
    %{
      token: token.token,
      type: "Bearer",
      expire_after: token.expired_after
    }
  end
end
