defmodule HelloPhoenix.PageController do
  use HelloPhoenix.Web, :controller

  plug :action

  def index(conn, _params) do
    conn
    |> put_flash(:info, "Welcome to Phoenix, from a flash notice!")
    |> put_flash(:error, "Let's pretend we have an error.")
    |> render "index.html"
  end

  def output_json(conn, _params) do
    json conn, %{ id: 1 }
  end
end
