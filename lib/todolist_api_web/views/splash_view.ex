defmodule TodolistApiWeb.SplashView do
  use TodolistApiWeb, :view
  alias TodolistApiWeb.UserView

  def render("show.json", %{options: options}) do
    %{
      user: renderUser(options.user),
      "timestamp": options.timestamp,
      "version": options.version,
      "update_version": options.update_version,
      "api_version": options.api_version,
      "is_essential_update": options.is_essential_update
    }
  end

  defp renderUser(nil), do: nil
  defp renderUser(user) do
    render_one(user, UserView, "user.json")
  end
end
