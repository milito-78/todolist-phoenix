defmodule TodolistApi.Repo do
  use Ecto.Repo,
    otp_app: :todolist_api,
    adapter: Ecto.Adapters.MyXQL
end
