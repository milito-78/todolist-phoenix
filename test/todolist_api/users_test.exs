defmodule TodolistApi.UsersTest do
  use TodolistApi.DataCase

  alias TodolistApi.Users

  describe "users" do
    alias TodolistApi.Users.User

    import TodolistApi.UsersFixtures

    @invalid_attrs %{created_at: nil, deleted_at: nil, email: nil, full_name: nil, id: nil, updated_at: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Users.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{created_at: ~N[2022-12-01 17:01:00], deleted_at: ~N[2022-12-01 17:01:00], email: "some email", full_name: "some full_name", id: 42, updated_at: ~N[2022-12-01 17:01:00]}

      assert {:ok, %User{} = user} = Users.create_user(valid_attrs)
      assert user.created_at == ~N[2022-12-01 17:01:00]
      assert user.deleted_at == ~N[2022-12-01 17:01:00]
      assert user.email == "some email"
      assert user.full_name == "some full_name"
      assert user.id == 42
      assert user.updated_at == ~N[2022-12-01 17:01:00]
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{created_at: ~N[2022-12-02 17:01:00], deleted_at: ~N[2022-12-02 17:01:00], email: "some updated email", full_name: "some updated full_name", id: 43, updated_at: ~N[2022-12-02 17:01:00]}

      assert {:ok, %User{} = user} = Users.update_user(user, update_attrs)
      assert user.created_at == ~N[2022-12-02 17:01:00]
      assert user.deleted_at == ~N[2022-12-02 17:01:00]
      assert user.email == "some updated email"
      assert user.full_name == "some updated full_name"
      assert user.id == 43
      assert user.updated_at == ~N[2022-12-02 17:01:00]
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end
