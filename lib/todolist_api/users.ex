defmodule TodolistApi.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias TodolistApi.Repo

  alias TodolistApi.Users.User
  alias TodolistApi.Tokens.AccessToken
  alias TodolistApi.Tokens


  def authenticate(email, password) do
    with %User{} = user <- get_user_by_email(email),
        true <- User.check_password(user.password,password),
        {:ok, %AccessToken{} = token, _} <- create_token(user) do
          {:ok, token,  user}
    else
      _ -> {:error , :unauthenticate}
    end
  end

  def register(attr) do
    with {:ok, %User{} = user} <- create_user(attr) do
      create_token(user)
    end
  end

  def logout(token) do
    Tokens.revoke_token(token)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user(id), do: Repo.get(User, id)

  def get_user_by_email(email), do: Repo.get_by(User, email: email)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end



  def create_token(user) do
    with {:ok, %AccessToken{} = token} <- Tokens.generate_token(user) do
      {:ok, token, user}
    end
  end

  def verify_token(token) do
    with {:ok, data} <- Tokens.verify_token(token),
         {:ok , user } <- get_user(data.user_id) do
         {:ok , user}
    else
      _ -> {:error, :invalid_token }
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
