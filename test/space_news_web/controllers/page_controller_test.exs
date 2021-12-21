defmodule SpaceNewsWeb.PageControllerTest do
  use SpaceNewsWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Space flight News"
    assert html_response(conn, 200) =~ "Back-end Challenge 2021 🏅 - Space Flight News"
    assert html_response(conn, 200) =~ "This is a challenge by Coodesh"
  end
end
