defmodule TodolistApi.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts inserted_at: :created_at

  schema "users" do
    field :email, :string
    field :full_name, :string
    field :password, :string
    field :deleted_at, :naive_datetime
    has_many :tasks, TodolistApi.Tasks.Task

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:full_name, :email, :password])
    |> validate_required([:full_name, :email, :password])
    |> unique_constraint(:email)
    |> hashed_password()
  end

  @doc false
  def change_password_changeset(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> hashed_password()
  end

  defp hashed_password(user) do
    with password <- fetch_field!(user,:password) do
      hashed = Bcrypt.hash_pwd_salt(password)
      put_change(user,:password,hashed)
    end
  end

  def check_password(hashed, password) do
    Bcrypt.verify_pass(password,hashed)
  end
end
