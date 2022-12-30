defmodule TodolistApi.Options do
  alias TodolistApi.Users
  alias TodolistApi.Users.User

  def splash(token \\ nil) do
    user = checkToken(token)

    %{
      "user": user,
      "timestamp": System.os_time(:second),
      "version": "1.0",
      "update_version": "1.0",
      "api_version": "1.0",
      "is_essential_update": false
    }
  end

  defp checkToken(nil), do: nil
  defp checkToken(token) do
    with {:ok , %User{} = user } <- Users.verify_token(token) do
      user
    else
      _ -> nil
    end
  end

end
