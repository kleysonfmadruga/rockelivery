defmodule Rockelivery.Users.Get do
  @moduledoc ~S"""
  Provides a function to try to get an User from the database.
  """

  alias Ecto.UUID
  alias Rockelivery.{Repo, User}

  @doc ~S"""
  Try to get an User by its UUID. If an UUID of an inexistent User
  is provided, returns an not found error. If the given UUID has an
  invalid format, returns a bad request error.

  ### Examples
      iex> Get.by_id("485154a5-d9c6-4a7c-922d-85b61aa0035c")
      {:ok,
        %User{
          ...
        }}

      iex> Get.by_id("219bb988-8604-48e4-bb38-5fa32dce33f5")
      {:error
        %{
          status: :not_found,
          result: "User not found"
        }}

      iex> Get.by_id("12345")
      {:error
        %{
          status: :bad_request,
          result: "Bad id format"
        }}
  """
  @spec by_id(UUID.t()) :: {:ok, %User{}} | {:error, %{status: :bad_request | :not_found, result: String.t()}}
  def by_id(id) do
    case UUID.cast(id) do
      :error -> {:error, status: :bad_request, result: "Bad id format"}
      {:ok, uuid} -> get(uuid)
    end
  end

  defp get(uuid) do
    case Repo.get(User, uuid) do
      nil -> {:error, %{status: :not_found, result: "User not found"}}
      user -> {:ok, user}
    end
  end
end
