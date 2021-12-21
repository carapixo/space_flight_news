defmodule SpaceNews.SpaceFlight.Launch do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "launches" do
    field :external_id, :string
    field :provider, :string

    belongs_to(:article, SpaceNews.SpaceFlight.Article)

    timestamps()
  end

  @required_params [:article_id, :external_id, :provider]
  @optional_params []

  def changeset(data, attrs) do
    data
    |> cast(attrs, @required_params ++ @optional_params)
    |> validate_required(@required_params)
  end
end
