defmodule TodolistApiWeb.TaskView do
  use TodolistApiWeb, :view
  alias TodolistApiWeb.TaskView

  def render("index.json", %{tasks: tasks}) do
    %{data: render_many(tasks, TaskView, "task.json")}
  end

  def render("show.json", %{task: task}) do
    %{data: render_one(task, TaskView, "task.json")}
  end

  def render("task.json", %{task: task}) do
    %{
      id: task.id,
      title: task.title,
      description: task.description,
      image_path: task.image_path,
      deadline: task.deadline,
      deleted_at: task.deleted_at
    }
  end
end
