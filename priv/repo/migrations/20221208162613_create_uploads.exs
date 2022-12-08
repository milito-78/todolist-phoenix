defmodule TodolistApi.Repo.Migrations.CreateUploads do
  use Ecto.Migration

  def change do
    create table(:uploads) do
      add :image_name, :string

      timestamps(inserted_at: :created_at, default: fragment("NOW()"))
    end
  end
end
