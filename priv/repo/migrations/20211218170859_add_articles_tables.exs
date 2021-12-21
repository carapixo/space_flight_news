defmodule SpaceNews.Repo.Migrations.AddArticlesTables do
  use Ecto.Migration

  def change do
    create table(:articles, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :external_id, :integer
      add :featured, :boolean
      add :title, :text
      add :url, :text
      add :image_url, :text
      add :news_site, :text
      add :summary, :text
      add :published_at, :text
      add :deleted_at, :timestamp

      timestamps()
    end

    create table(:launches, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :article_id, references(:articles, on_delete: :delete_all, type: :uuid)
      add :external_id, :text
      add :provider, :text

      timestamps()
    end

    create table(:events, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :article_id, references(:articles, on_delete: :delete_all, type: :uuid)
      add :external_id, :integer
      add :provider, :text

      timestamps()
    end

    create index(:articles, :external_id)
  end
end
