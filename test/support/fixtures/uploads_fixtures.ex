defmodule TodolistApi.UploadsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodolistApi.Uploads` context.
  """

  @doc """
  Generate a upload.
  """
  def upload_fixture(attrs \\ %{}) do
    {:ok, upload} =
      attrs
      |> Enum.into(%{
        image_name: "some image_name"
      })
      |> TodolistApi.Uploads.create_upload()

    upload
  end
end
