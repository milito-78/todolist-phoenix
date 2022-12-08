defmodule TodolistApi.Tasks do
  @moduledoc """
  The Tasks context.
  """
  import Ecto.Query, warn: false
  alias TodolistApi.Repo
  alias TodolistApi.Tasks.Task

  def user_tasks_list(user_id,page) do
    from(c in Task, where: c.user_id == ^user_id)
    |> Repo.paginate(page: Repo.get_page(page))
  end

  def get_user_task!(id,user_id) do
    from(t in Task, where: t.user_id == ^user_id and t.id == ^id)
    |>Repo.one!
  end

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(user_id, attrs \\ %{}) do
    %Task{}
    |> Task.changeset(cast(Map.put(attrs,"user_id", user_id)))
    |> Repo.insert()
  end

  defp cast(attrs) do
    attrs
    |> Map.put("image_path",attrs["image"])
    |> Map.delete("image")
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.update_changeset(cast(attrs))
    |> Repo.update()
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

end
