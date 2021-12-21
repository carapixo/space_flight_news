defmodule SpaceNews.SpaceFlight.Article do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "articles" do
    field :external_id, :integer
    field :featured, :boolean
    field :title, :string
    field :url, :string
    field :image_url, :string
    field :news_site, :string
    field :summary, :string
    field :published_at, :string
    field :deleted_at, :naive_datetime

    has_many(:launches, SpaceNews.SpaceFlight.Launch, on_delete: :delete_all)
    has_many(:events, SpaceNews.SpaceFlight.Event, on_delete: :delete_all)

    timestamps()
  end

  @required_params [
    :featured,
    :title,
    :url,
    :image_url,
    :news_site,
    :summary,
    :published_at
  ]
  @optional_params [:external_id, :deleted_at]

  def changeset(data, attrs) do
    data
    |> cast(attrs, @required_params ++ @optional_params)
    |> validate_required(@required_params)
  end
end
