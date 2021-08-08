defmodule RockeliveryWeb.WelcomeController do
  use RockeliveryWeb, :controller

  def index(conn, _params) do
    conn
    |> put_status(:ok)
    |> text("Hello, Phoenix")
  end
end
