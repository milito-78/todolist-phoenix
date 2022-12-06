defmodule TodolistApiWeb.TaskControllerTest do
  use TodolistApiWeb.ConnCase

  import TodolistApi.TasksFixtures

  alias TodolistApi.Tasks.Task

  @create_attrs %{
    deadline: ~N[2022-12-05 21:01:00],
    deleted_at: ~N[2022-12-05 21:01:00],
    description: "some description",
    image_path: "some image_path",
    title: "some title"
  }
  @update_attrs %{
    deadline: ~N[2022-12-06 21:01:00],
    deleted_at: ~N[2022-12-06 21:01:00],
    description: "some updated description",
    image_path: "some updated image_path",
    title: "some updated title"
  }
  @invalid_attrs %{deadline: nil, deleted_at: nil, description: nil, image_path: nil, title: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tasks", %{conn: conn} do
      conn = get(conn, Routes.task_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create task" do
    test "renders task when data is valid", %{conn: conn} do
      conn = post(conn, Routes.task_path(conn, :create), task: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.task_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "deadline" => "2022-12-05T21:01:00",
               "deleted_at" => "2022-12-05T21:01:00",
               "description" => "some description",
               "image_path" => "some image_path",
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.task_path(conn, :create), task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update task" do
    setup [:create_task]

    test "renders task when data is valid", %{conn: conn, task: %Task{id: id} = task} do
      conn = put(conn, Routes.task_path(conn, :update, task), task: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.task_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "deadline" => "2022-12-06T21:01:00",
               "deleted_at" => "2022-12-06T21:01:00",
               "description" => "some updated description",
               "image_path" => "some updated image_path",
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, task: task} do
      conn = put(conn, Routes.task_path(conn, :update, task), task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete task" do
    setup [:create_task]

    test "deletes chosen task", %{conn: conn, task: task} do
      conn = delete(conn, Routes.task_path(conn, :delete, task))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.task_path(conn, :show, task))
      end
    end
  end

  defp create_task(_) do
    task = task_fixture()
    %{task: task}
  end
end
