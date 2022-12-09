defmodule TodolistApi.Workers.VerifyCodeEmail do
  use Que.Worker, concurrency: 2

  def perform(email: email,code: code, type: type) do
    Process.sleep(5000)
    IO.inspect(type)
    IO.puts("to #{email} : code #{code}")
  end


  def on_failure({campaign, user}, error) do
    Logger.debug("Campaign email to #{inspect(user)} failed: #{inspect(error)}")
  end
end
