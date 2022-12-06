defmodule TodolistApi.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string, null: false
      add :description, :text, null: true
      add :image_path, :string, null: true, default: nil
      add :deadline, :naive_datetime, null: true, default: nil
      add :deleted_at, :naive_datetime, null: true, default: nil
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(inserted_at: :created_at, default: fragment("NOW()"))
    end

    create index(:tasks, [:user_id])
  end
end
