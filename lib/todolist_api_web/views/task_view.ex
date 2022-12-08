defmodule TodolistApiWeb.TaskView do
  use TodolistApiWeb, :view
  alias TodolistApiWeb.TaskView

  def render("paginate.json", %{paginate: paginate}) do
    %{
      items: render_many(paginate.entries, TaskView, "task.json"),

      "page": paginate.page_number,
      "first_page": 1,
      "next_page": next_page_number(paginate.page_number,paginate.total_pages),
      "per_page": paginate.page_size,
      "count": paginate.total_entries,
    }
  end

  def render("index.json", %{tasks: tasks}) do
    %{data: render_many(tasks, TaskView, "task.json")}
  end

  def render("show.json", %{task: task}) do
    %{
      "message": "success",
      data: render_one(task, TaskView, "task.json")
    }
  end

  def render("create.json", %{task: task}) do
    %{
      "message": "Task created successfully",
      data: render_one(task, TaskView, "task.json")
    }
  end

  def render("delete.json", _params) do
    %{
      "message": "Task deleted successfully"
    }
  end

  def render("task.json", %{task: task}) do
    %{
      id: task.id,
      title: task.title,
      description: task.description,
      image_path: task.image_path,
      deadline: task.deadline,
      created_at: task.created_at,
      updated_at: task.updated_at,
    }
  end


  def next_page_number(current_page,total_page) do
    if current_page + 1 <= total_page do
      current_page + 1
    else
      0
    end
  end

end
