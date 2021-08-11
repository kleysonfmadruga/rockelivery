defmodule Rockelivery.Users.Create do
  @moduledoc ~S"""
  Provides a function to try to save an User in the database.
  """

  alias Rockelivery.{Repo, User}

  @doc ~S"""
  Creates the an Ecto.Changeset from the params and try to insert it
  in the database.

  ### Examples
      iex> user_params = %{name: "Joe", ...}
      iex> Create.call(user_params)
      {:ok,
        %User{
          name: "Joe",
          ...
      }}

      iex> invalid_params = %{name: "Joe", ...}
      iex> Create.call(invalid_params)
      {:error,
        %Ecto.Changeset{
          valid?: false,
          errors: [...],
          changeset: %{...},
          ...
      }}
  """
  @spec call(Map.t()) :: {:ok, Map.t()} | {:error, Ecto.Changeset.t()}
  def call(params) do
    params
    |> User.changeset()
    |> Repo.insert()
  end
end
