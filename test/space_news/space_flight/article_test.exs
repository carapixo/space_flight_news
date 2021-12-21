defmodule SpaceNews.SpaceFlight.ArticleTest do
  use SpaceNewsWeb.ConnCase, async: true

  alias SpaceNews.SpaceFlight.Article

  describe "changeset/2" do
    test "is not valid with invalid attributes" do
      changeset = Article.changeset(%Article{}, %{})

      assert changeset.errors == [
               {:featured, {"can't be blank", [validation: :required]}},
               {:title, {"can't be blank", [validation: :required]}},
               {:url, {"can't be blank", [validation: :required]}},
               {:image_url, {"can't be blank", [validation: :required]}},
               {:news_site, {"can't be blank", [validation: :required]}},
               {:summary, {"can't be blank", [validation: :required]}},
               {:published_at, {"can't be blank", [validation: :required]}}
             ]
    end

    test "is valid with valid attributes" do
      changeset =
        Article.changeset(%Article{}, %{
          featured: false,
          title: "Title",
          url: "example.com",
          image_url: "image.png",
          news_site: "Nasa",
          summary: "Summary",
          published_at: "2021-12-20T10:46:42.000Z"
        })

      assert changeset.valid?
    end
  end
end
