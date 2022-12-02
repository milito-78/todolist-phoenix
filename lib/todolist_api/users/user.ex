defmodule TodolistApi.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :created_at, :naive_datetime
    field :deleted_at, :naive_datetime
    field :email, :string
    field :full_name, :string
    field :id, :integer
    field :updated_at, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:id, :full_name, :email, :created_at, :updated_at, :deleted_at])
    |> validate_required([:id, :full_name, :email, :created_at, :updated_at, :deleted_at])
    |> unique_constraint(:email)
  end
end
