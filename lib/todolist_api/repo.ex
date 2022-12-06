defmodule TodolistApi.Repo do
  use Ecto.Repo,
    otp_app: :todolist_api,
    adapter: Ecto.Adapters.MyXQL

  use Scrivener, page_size: 10

  def get_page(page) when page <= 0 do
    1
  end

  def get_page(page), do: page
end
