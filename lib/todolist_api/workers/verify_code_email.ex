defmodule TodolistApi.Workers.VerifyCodeEmail do
  require Logger
  use Que.Worker, concurrency: 1
  alias TodolistApi.Mails.ForgetPasswordMail
  alias TodolistApi.Mailer

  def perform( email: email, code: code, type: type) do
    case type do
      :forget -> send_forget(email,code)
      _-> raise("unknown type")
    end
  end


  def on_failure({campaign, user}, error) do
    Logger.error("Campaign email to #{inspect(user)} failed: #{inspect(error)}")
  end

  defp send_forget(email,code) do
    ForgetPasswordMail.verify_code(email,code)
    |> Mailer.deliver()
  end
end
