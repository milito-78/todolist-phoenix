defmodule TodolistApi.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts inserted_at: :created_at

  schema "tasks" do
    field :deadline, :naive_datetime
    field :deleted_at, :naive_datetime
    field :description, :string
    field :image_path, :string
    field :title, :string
    field :user_id, :id
    # belongs_to :user, TodolistApi.Users.User

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :image_path, :deadline,:user_id])
    |> validate_required([:title, :description, :image_path, :deadline,:user_id])
  end
end
