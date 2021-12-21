defmodule SpaceNews.ImportArticles do
  import Ecto.Query, warn: false

  alias SpaceNews.Repo
  alias SpaceNews.SpaceFlight.{Article, Event, Launch}
  alias SpaceNews.Discord
  alias SpaceNews.Discord.MessageSending

  def upsert_articles(values) do
    case Repo.get_by(Article, external_id: values.external_id) do
      nil ->
        {:insert,
         Repo.insert_or_update(Article.changeset(%Article{}, values), on_conflict: :nothing)}
        |> upsert_launches(values)
        |> upsert_events(values)

      article ->
        {:update,
         Repo.insert_or_update(Article.changeset(article, values), on_conflict: :nothing)}
        |> upsert_launches(values)
        |> upsert_events(values)
    end
  end

  defp upsert_launches({_, {_, %{id: id}}} = upsert, article) when length(article.launches) > 0 do
    for launch <- article.launches do
      case Repo.get_by(Launch, article_id: id, external_id: launch.external_id) do
        nil ->
          launch = Map.put(launch, :article_id, id)

          {:insert,
           Repo.insert_or_update(Launch.changeset(%Launch{}, launch),
             on_conflict: :nothing
           )}

        result ->
          launch = Map.put(launch, :article_id, id)

          {:update,
           Repo.insert_or_update(Launch.changeset(result, launch), on_conflict: :nothing)}
      end
    end

    upsert
  end

  defp upsert_launches(upsert, _values), do: upsert

  defp upsert_events({_, {_, %{id: id}}} = upsert, article) when length(article.events) > 0 do
    for event <- article.events do
      case Repo.get_by(Event, article_id: id, external_id: event.external_id) do
        nil ->
          event = Map.put(event, :article_id, id)

          {:insert,
           Repo.insert_or_update(Event.changeset(%Event{}, event),
             on_conflict: :nothing
           )}

        result ->
          event = Map.put(event, :article_id, id)

          {:update, Repo.insert_or_update(Event.changeset(result, event), on_conflict: :nothing)}
      end
    end

    upsert
  end

  defp upsert_events(upsert, _values), do: upsert

  def report_changeset_error({:error, changeset}) do
    MessageSending.new(
      "Erro consulta API",
      "Ocorreu algum erro inesperado na consulta da API: #{changeset}"
    )
    |> Discord.deliver_async()
  end

  def report_changeset_error(changeset) do
    changeset
  end
end
