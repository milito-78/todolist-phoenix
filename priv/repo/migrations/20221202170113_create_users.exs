defmodule TodolistApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :id, :integer
      add :full_name, :string, null: false
      add :email, :string, null: false
      add :password, :string, null: false
      add :deleted_at, :naive_datetime, null: true, default: nil

      timestamps(inserted_at: :created_at, default: fragment("NOW()"))
    end

    create unique_index(:users, [:email])
  end
end
