defmodule SpaceNews.SpaceFlight.EventTest do
  use SpaceNewsWeb.ConnCase, async: true

  alias SpaceNews.Repo
  alias SpaceNews.SpaceFlight.Article
  alias SpaceNews.SpaceFlight.Event

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

  describe "changeset/2" do
    test "is not valid with invalid attributes" do
      changeset = Event.changeset(%Event{}, %{})

      assert changeset.errors == [
               article_id: {"can't be blank", [validation: :required]},
               external_id: {"can't be blank", [validation: :required]},
               provider: {"can't be blank", [validation: :required]}
             ]
    end

    test "is valid with valid attributes", %{article: article} do
      changeset =
        Event.changeset(%Event{}, %{
          article_id: article.id,
          external_id: 123,
          provider: "Provider"
        })

      assert changeset.valid?
    end
  end
end
