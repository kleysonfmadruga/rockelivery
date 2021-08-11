defmodule Rockelivery.User do
  @moduledoc ~S"""
  Provides an User struct and a function to generate an Ecto.Changeset struct.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @type t() :: %__MODULE__{
    id: Ecto.UUID.t(),
    age: non_neg_integer(),
    address: String.t(),
    cep: String.t(),
    cpf: String.t(),
    email: String.t(),
    password: String.t(),
    password_hash: String.t(),
    name: String.t()
  }

  @primary_key {:id, :binary_id, auto_generate: true}
  @required_fields [:age, :address, :cep, :cpf, :email, :password, :name]

  schema "users" do
    field :age, :integer
    field :address, :string
    field :cep, :string
    field :cpf, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :name, :string

    timestamps()
  end

  @doc ~S"""
  Generates an Ecto.Changeset struct from a map of user data.

  ### Examples
      iex> user_params = %{name: "Joe", ...}
      iex> Rockelivery.User.changeset(user_params)
      #Ecto.Changeset<
        valid?: true,
        changeset: %{...},
        errors: [],
        ...
      >

      iex> invalid_params = %{name: "Joe", ...}
      iex> Rockelivery.User.changeset(invalid_params)
      #Ecto.Changeset<
        valid?: false,
        changeset: %{...},
        errors: [...],
        ...
      >
  """
  @spec changeset(Map.t()) :: Ecto.Changeset.t()
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:password, min: 6)
    |> validate_length(:cep, is: 8)
    |> validate_length(:cpf, is: 11)
    |> validate_format(:email, ~r/@/)
    |> validate_number(:age, greater_than_or_equal_to: 18)
    |> unique_constraint([:email])
    |> unique_constraint([:cpf])
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Pbkdf2.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
