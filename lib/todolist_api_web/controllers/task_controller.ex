defmodule TodolistApiWeb.TaskController do
  use TodolistApiWeb, :controller

  alias TodolistApi.Tasks
  alias TodolistApi.Tasks.Task

  action_fallback TodolistApiWeb.FallbackController

  def index(conn, params) do
    conn
    |> render(
        "paginate.json",
        paginate: Tasks.user_tasks_list(
          conn.assigns[:current_user].id,
          Map.get(params, "page", 1)
        )
      )
  end

  def create(conn, %{"task" => task_params}) do
    with {:ok, %Task{} = task} <- Tasks.create_task(task_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.task_path(conn, :show, task))
      |> render("show.json", task: task)
    end
  end

  def show(conn, %{"id" => id}) do
    conn
    |> render("show.json", task: Tasks.get_user_task!(id,conn.assigns[:current_user].id))
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tasks.get_task!(id)

    with {:ok, %Task{} = task} <- Tasks.update_task(task, task_params) do
      render(conn, "show.json", task: task)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_user_task!(id,conn.assigns[:current_user].id)

    with {:ok, %Task{}} <- Tasks.delete_task(task) do
      render(conn, "delete.json")
    end
  end
end
