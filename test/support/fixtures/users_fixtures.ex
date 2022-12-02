defmodule TodolistApi.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodolistApi.Users` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some email#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        created_at: ~N[2022-12-01 17:01:00],
        deleted_at: ~N[2022-12-01 17:01:00],
        email: unique_user_email(),
        full_name: "some full_name",
        id: 42,
        updated_at: ~N[2022-12-01 17:01:00]
      })
      |> TodolistApi.Users.create_user()

    user
  end
end
