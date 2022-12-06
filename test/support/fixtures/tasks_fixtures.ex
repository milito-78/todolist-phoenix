defmodule TodolistApi.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodolistApi.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        deadline: ~N[2022-12-05 21:01:00],
        deleted_at: ~N[2022-12-05 21:01:00],
        description: "some description",
        image_path: "some image_path",
        title: "some title"
      })
      |> TodolistApi.Tasks.create_task()

    task
  end
end
