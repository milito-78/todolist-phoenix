defmodule ReceiptApi.Repo.Migrations.CreateAccessTokensTable do
  use Ecto.Migration

  def change do
    create table(:access_tokens) do
      add :user_id, references(:users, on_delete: :delete_all, on_update: :update_all), null: false
      add :token, :string, null: false
      add :expired_after, :integer, null: false

      timestamps(inserted_at: :created_at, default: fragment("NOW()"))
    end

    create unique_index(:access_tokens, [:token])
  end
end
