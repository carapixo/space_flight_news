defmodule SpaceNews.ArticlesTest do
  use SpaceNewsWeb.ConnCase, async: true

  alias SpaceNews.Articles
  alias SpaceNews.Repo
  alias SpaceNews.SpaceFlight.Article

  setup do
    article =
      %Article{
        deleted_at: nil,
        external_id: 13368,
        featured: false,
        image_url: "https://spacenews.com/wp-content/uploads/2021/08/starliner-oft2-rollout3.jpg",
        inserted_at: ~N[2021-12-20 12:15:01],
        news_site: "SpaceNews",
        published_at: "2021-12-20T10:46:42.000Z",
        summary:
          "NASA and Boeing are planning no earlier than May 2022 for the rescheduled second uncrewed test flight of the CST-100 Starliner spacecraft after deciding to change service modules for that mission.",
        title: "Boeing Starliner test flight planned for spring 2022",
        updated_at: ~N[2021-12-20 12:15:01],
        url: "https://spacenews.com/boeing-starliner-test-flight-planned-for-spring-2022/"
      }
      |> Repo.insert!()

    %{article: article}
  end

  test "list_article/1", %{article: article} do
    result = Articles.list_articles(1)
    assert result.results == [article]
  end

  test "get_article/1", %{article: article} do
    result = Articles.get_article(article.id)
    assert result == article
  end

  test "change_article/1", %{article: article} do
    assert %Ecto.Changeset{} = Articles.change_article(article)
  end
end
