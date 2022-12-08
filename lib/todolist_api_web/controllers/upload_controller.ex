defmodule TodolistApiWeb.UploadController do
  use TodolistApiWeb, :controller

  alias TodolistApi.Uploads
  alias TodolistApi.Uploads.Upload

  action_fallback TodolistApiWeb.FallbackController

  def create(conn, %{"image" => upload }) do
    file_name = "#{conn.assigns[:current_user].id}-#{UUID.uuid4()}-task#{Path.extname(upload.filename)}"
    File.cp(upload.path, Path.absname("media/images/" <> file_name))
    with {:ok, %Upload{} = upload} <- Uploads.create_upload(%{"image_name" => file_name}) do
      conn
      |> put_status(:created)
      |> render("create.json", upload: upload)
    end
  end

end
