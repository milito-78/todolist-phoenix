defmodule TodolistApi.Uploads.Upload do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts inserted_at: :created_at

  schema "uploads" do
    field :image_name, :string
    timestamps()
  end

  @doc false
  def changeset(upload, attrs) do
    upload
    |> cast(attrs, [:image_name])
    |> validate_required([:image_name])
  end
end
