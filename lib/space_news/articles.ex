defmodule SpaceNews.Articles do
  import Ecto.Query, warn: false

  alias SpaceNews.Repo
  alias SpaceNews.SpaceFlight.Article
  alias SpaceNews.Paginator

  def list_articles(page \\ 1) do
    Article
    |> where([a], is_nil(a.deleted_at))
    |> order_by(desc: :published_at)
    |> Paginator.paginate(page, nil)
  end

  def get_article(article_id) do
    Repo.get_by(Article, id: article_id)
  end

  def create_article(attrs \\ %{}) do
    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
  end

  def change_article(%Article{} = article, attrs \\ %{}) do
    Article.changeset(article, attrs)
  end

  def update_article(%Article{} = article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update()
  end

  def delete_article_by_id(article_id) do
    Repo.get_by(Article, id: article_id)
    |> Article.changeset(%{deleted_at: DateTime.utc_now()})
    |> Repo.update()
  end
end
