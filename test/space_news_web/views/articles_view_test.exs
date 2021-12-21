defmodule SpaceNewsWeb.ArticlesViewTest do
  use SpaceNewsWeb.ConnCase, async: true

  alias SpaceNewsWeb.ArticlesView

  test "return formatted date" do
    assert ArticlesView.format_article_date("2021-12-20T12:16:42.000Z") == "20/12/2021"
  end

  describe "previous_page_number/1" do
    test "returns 1 when it is the first page" do
      assert ArticlesView.previous_page_number(1) == 1
    end

    test "returns page - 1 when it is not the first page" do
      assert ArticlesView.previous_page_number(10) == 9
    end
  end

  describe "next_page_number/2" do
    test "returns the last page when it is on the last page" do
      assert ArticlesView.next_page_number(10, 10) == 10
    end

    test "returns page + 1 when not on the last page" do
      assert ArticlesView.next_page_number(8, 10) == 9
    end
  end
end
