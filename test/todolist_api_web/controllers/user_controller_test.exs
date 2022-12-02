defmodule TodolistApiWeb.UserControllerTest do
  use TodolistApiWeb.ConnCase

  import TodolistApi.UsersFixtures

  alias TodolistApi.Users.User

  @create_attrs %{
    created_at: ~N[2022-12-01 17:01:00],
    deleted_at: ~N[2022-12-01 17:01:00],
    email: "some email",
    full_name: "some full_name",
    id: 42,
    updated_at: ~N[2022-12-01 17:01:00]
  }
  @update_attrs %{
    created_at: ~N[2022-12-02 17:01:00],
    deleted_at: ~N[2022-12-02 17:01:00],
    email: "some updated email",
    full_name: "some updated full_name",
    id: 43,
    updated_at: ~N[2022-12-02 17:01:00]
  }
  @invalid_attrs %{created_at: nil, deleted_at: nil, email: nil, full_name: nil, id: nil, updated_at: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "created_at" => "2022-12-01T17:01:00",
               "deleted_at" => "2022-12-01T17:01:00",
               "email" => "some email",
               "full_name" => "some full_name",
               "id" => 42,
               "updated_at" => "2022-12-01T17:01:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "created_at" => "2022-12-02T17:01:00",
               "deleted_at" => "2022-12-02T17:01:00",
               "email" => "some updated email",
               "full_name" => "some updated full_name",
               "id" => 43,
               "updated_at" => "2022-12-02T17:01:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
