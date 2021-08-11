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
        %{
          status: :bad_request,
          result: %Ecto.Changeset{
            valid?: false,
            ...
          }
        }
      }}
  """
  @spec call(Map.t()) :: {:ok, User.t()} | {:error, %{result: Ecto.Changeset.t(), status: :bad_request}}
  def call(params) do
    params
    |> User.changeset()
    |> Repo.insert()
    |> handle_insert()
  end

  defp handle_insert({:ok, %User{}} = result), do: result

  defp handle_insert({:error, result}) do
    {:error, %{
      status: :bad_request,
      result: result
    }}
  end
end
