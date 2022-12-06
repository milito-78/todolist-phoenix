defmodule TodolistApi.TasksTest do
  use TodolistApi.DataCase

  alias TodolistApi.Tasks

  describe "tasks" do
    alias TodolistApi.Tasks.Task

    import TodolistApi.TasksFixtures

    @invalid_attrs %{deadline: nil, deleted_at: nil, description: nil, image_path: nil, title: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Tasks.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Tasks.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{deadline: ~N[2022-12-05 21:01:00], deleted_at: ~N[2022-12-05 21:01:00], description: "some description", image_path: "some image_path", title: "some title"}

      assert {:ok, %Task{} = task} = Tasks.create_task(valid_attrs)
      assert task.deadline == ~N[2022-12-05 21:01:00]
      assert task.deleted_at == ~N[2022-12-05 21:01:00]
      assert task.description == "some description"
      assert task.image_path == "some image_path"
      assert task.title == "some title"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{deadline: ~N[2022-12-06 21:01:00], deleted_at: ~N[2022-12-06 21:01:00], description: "some updated description", image_path: "some updated image_path", title: "some updated title"}

      assert {:ok, %Task{} = task} = Tasks.update_task(task, update_attrs)
      assert task.deadline == ~N[2022-12-06 21:01:00]
      assert task.deleted_at == ~N[2022-12-06 21:01:00]
      assert task.description == "some updated description"
      assert task.image_path == "some updated image_path"
      assert task.title == "some updated title"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task == Tasks.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end
  end
end
