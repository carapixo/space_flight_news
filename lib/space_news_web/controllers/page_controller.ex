defmodule SpaceNewsWeb.PageController do
  use SpaceNewsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
