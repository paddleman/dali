defmodule DaliWeb.PageController do
  use DaliWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
