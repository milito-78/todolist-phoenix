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

  def create(conn, task_params) do
    with {:ok, %Task{} = task} <- Tasks.create_task(conn.assigns[:current_user].id,task_params) do
      conn
      |> put_status(:created)
      |> render("create.json", task: task)
    end
  end

  def show(conn, %{"id" => id}) do
    conn
    |> render("show.json", task: Tasks.get_user_task!(id,conn.assigns[:current_user].id))
  end

  def update(conn, params) do
    task = Tasks.get_user_task!(params["id"],conn.assigns[:current_user].id)

    with {:ok,_} <- Tasks.update_task(task, params) do
      IO.inspect("ssss")
      conn
      |> send_resp(204, "")
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_user_task!(id,conn.assigns[:current_user].id)

    with {:ok, %Task{}} <- Tasks.delete_task(task) do
      render(conn, "delete.json")
    end
  end
end
