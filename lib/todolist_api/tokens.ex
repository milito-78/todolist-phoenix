defmodule TodolistApi.Tokens do
  @moduledoc """
  The Access Tokens context.
  """
  import Ecto.Query, warn: false
  alias TodolistApi.Repo
  alias TodolistApi.Tokens.AccessToken

  @signing_salt "This is Rammstein"
  # token for 2 week
  @token_age_secs 14 * 86_400

  @doc """
  Create token for given data
  """
  @spec sign(map()) :: binary()
  def sign(data) do
    Phoenix.Token.sign(TodolistApiWeb.Endpoint, @signing_salt, data)
  end

  def generate_token(user) do
    token = sign(user.email)
    create_token(%{token: token, user_id: user.id, expired_after: @token_age_secs})
  end

  @doc """
  Verify given token by:
  - Verify token signature
  - Verify expiration time
  """
  @spec verify(String.t()) :: {:ok, any()} | {:error, :unauthenticated}
  def verify(token, token_age \\ @token_age_secs) do
    case Phoenix.Token.verify(TodolistApiWeb.Endpoint, @signing_salt, token,max_age: token_age) do
      {:ok, data} -> {:ok, data}
      _error -> {:error, :unauthenticated}
    end
  end

  def verify_token(token) do
    with %AccessToken{} = access <- get_token(token),
        {:ok, _ } <- verify(token,access.expired_after) do
          {:ok, access}
    else
        _ -> {:error, :unauthenticated}
    end
  end

  def revoke_all(user_id) do
    from(t in AccessToken, where: t.user_id == ^user_id)
    |> Repo.delete_all()
  end

  def revoke_token(token) do
    from(t in AccessToken, where: t.token == ^token)
    |> Repo.delete_all()
  end

  def create_token(attrs \\ %{}) do
    %AccessToken{}
    |> AccessToken.changeset(attrs)
    |> Repo.insert()
  end

  def get_token(token), do: Repo.get_by(AccessToken, token: token)

end
