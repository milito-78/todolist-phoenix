defmodule TodolistApi.Tokens.AccessToken do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts inserted_at: :created_at

  schema "access_tokens" do
    field :user_id, :id
    field :token, :string
    field :expired_after, :integer

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:user_id, :token, :expired_after])
    |> validate_required([:user_id, :token, :expired_after])
    |> unique_constraint([:token])
  end
end
