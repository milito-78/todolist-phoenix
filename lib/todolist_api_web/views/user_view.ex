defmodule TodolistApiWeb.UserView do
  use TodolistApiWeb, :view
  alias TodolistApiWeb.{UserView,TokenView}

  def render("login.json", %{user: user, token: token}) do
    %{
      message: "Login successfully",
      data: %{
        user: render_one(user, UserView, "user.json"),
        token: render_one(token, TokenView, "token.json")
      }
    }
  end

  def render("register.json", %{user: user, token: token}) do
    %{
      message: "Register successfully",
      data: %{
        user: render_one(user, UserView, "user.json"),
        token: render_one(token, TokenView, "token.json")
      }
    }
  end

  def render("show.json", %{user: user}) do
    %{
      message: "Success",
      data: %{
        user: render_one(user, UserView, "user.json")
      }
    }
  end


  def render("search.json", %{users: users}) do
    %{
      message: "Success",
      data: render_many(users, UserView, "user.json")
    }
  end


  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      full_name: user.full_name,
      "created_at": user.created_at,
      "updated_at": user.updated_at
    }
  end
end
