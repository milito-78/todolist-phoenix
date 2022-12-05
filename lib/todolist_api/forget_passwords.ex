defmodule TodolistApi.ForgetPasswords do
  @moduledoc """
  The Forget Password context.
  """
  alias TodolistApi.Repo
  alias TodolistApi.Users
  alias TodolistApi.Users.User
  alias TodolistApi.ForgetPasswords.ForgetPassword
  alias TodolistApi.Tokens

  def forget_password(email, silent \\ false) do
    with %User{} = user <- Users.get_user_by_email(email),
        {:ok, %ForgetPassword{} = forget} <- generate_token(%{user_id: user.id,email: email}) do
          if !silent do
            send_email(user.email,forget.code)
          end
          {:ok , forget}
    else
        {:error, %ForgetPassword{} = forget} -> { :error, forget }
        nil -> {:error, :undefined}
    end
  end

  def generate_token(%{user_id: user_id,email: email}) do
    key = "forget:" <> email
    {:ok, value} = Cachex.get(:my_cache, key)
    if value != nil do
      with {:ok, %ForgetPassword{} = forget} <- ForgetPassword.decode(value),
            {:ok, token} = Cachex.get(:my_cache, key <> ":token") do
            {:error, %{forget | token: token }}
      else
        _ -> forget =
          %ForgetPassword{uuid: user_id,email: email, code: random_code(), timestamps: System.os_time(:second) + 120, expire: 120}
          |> _generate_token()
        Cachex.put(:my_cache, key, ForgetPassword.encode(forget),ttl: :timer.seconds(120))
        Cachex.put(:my_cache, key <> ":token", forget.token, ttl: :timer.seconds(120))
        { :ok, forget }
      end
    else
      forget =
        %ForgetPassword{uuid: user_id,email: email, code: random_code(), timestamps: System.os_time(:second) + 120, expire: 120}
        |> _generate_token()
      Cachex.put(:my_cache, key, ForgetPassword.encode(forget),ttl: :timer.seconds(120))
      Cachex.put(:my_cache, key <> ":token", forget.token, ttl: :timer.seconds(120))
      { :ok, forget }
    end
  end

  defp _generate_token(data) do
    %{data | token: data |> ForgetPassword.toMap() |> Tokens.sign() }
  end

  defp random_code() do
    Enum.random(10000..99999)
  end

  defp send_email(email,code) do
    # TODO send code by queue
    IO.puts("#{email} : #{code}")
  end

end
