defmodule TodolistApiWeb.UserView do
  use TodolistApiWeb, :view
  alias TodolistApiWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      id: user.id,
      full_name: user.full_name,
      email: user.email,
      created_at: user.created_at,
      updated_at: user.updated_at,
      deleted_at: user.deleted_at
    }
  end
end
