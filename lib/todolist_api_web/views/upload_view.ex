defmodule TodolistApiWeb.UploadView do
  use TodolistApiWeb, :view
  alias TodolistApiWeb.UploadView


  def render("create.json", %{upload: upload}) do
    %{
      "message": "File uploaded successfully",
      data: render_one(upload, UploadView, "upload.json")
    }
  end

  def render("upload.json", %{upload: upload}) do
    %{
      id: upload.id,
      file_name: upload.image_name,
      file_path: TodolistApiWeb.Endpoint.url() <> "/media/images/" <> upload.image_name
    }
  end
end
