defmodule SpaceNewsWeb.ArticlesController do
  use SpaceNewsWeb, :controller

  alias SpaceNews.Articles
  alias SpaceNews.SpaceFlight.Article

  def index(conn, params) do
    page = params["page"] || 1
    articles = Articles.list_articles(page)

    render(conn, "index.html", articles: articles)
  end

  def show(conn, %{"id" => article_id}) do
    article = Articles.get_article(article_id)

    render(conn, "show.html", article: article)
  end

  def new(conn, _) do
    changeset = Articles.change_article(%Article{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"article" => article_params}) do
    case Articles.create_article(article_params) do
      {:ok, _} ->
        conn
        |> redirect(to: Routes.articles_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => article_id}) do
    article = Articles.get_article(article_id)
    changeset = Articles.change_article(article)

    render(conn, "edit.html", article: article, changeset: changeset)
  end

  def update(conn, %{"id" => article_id, "article" => article_params}) do
    article = Articles.get_article(article_id)

    case Articles.update_article(article, article_params) do
      {:ok, _} ->
        conn
        |> redirect(to: Routes.articles_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("edit.html", article: article, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => article_id}) do
    Articles.delete_article_by_id(article_id)

    redirect(conn, to: Routes.articles_path(conn, :index))
  end
end
