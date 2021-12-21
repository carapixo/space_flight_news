defmodule SpaceNews.SpaceFlight.SpaceFlightAPI do
  import Ecto.Query, warn: false
  use HTTPoison.Base

  alias SpaceNews.Discord
  alias SpaceNews.Discord.MessageSending
  alias SpaceNews.ImportArticles

  @url "https://api.spaceflightnewsapi.net/v3"
  @path "/articles"

  def import do
    case get(@path) do
      {:error, %HTTPoison.Error{} = error} ->
        {:error, error.reason}
        |> notify()

      {:ok, %HTTPoison.Response{status_code: 200, body: :error}} ->
        {:error, "Invalid body returned"}
        |> notify()

      {:ok, %HTTPoison.Response{status_code: 200, body: decoded_body}} ->
        decoded_body
        |> Enum.map(&build_attrs/1)
        |> Enum.map(&ImportArticles.upsert_articles/1)
        |> Enum.map(&ImportArticles.report_changeset_error/1)

      _ ->
        {:error, :unexpected_response}
        |> notify()
    end
  end

  @impl true
  def process_request_url(path) do
    @url <> path
  end

  @impl true
  def process_response_body(body) do
    case Jason.decode(body) do
      {:ok, decoded_body} -> decoded_body
      {:error, _error} -> :error
    end
  end

  defp build_attrs(article) do
    %{
      external_id: article["id"],
      featured: article["featured"],
      title: article["title"],
      url: article["url"],
      image_url: article["imageUrl"],
      news_site: article["newsSite"],
      summary: article["summary"],
      published_at: article["publishedAt"],
      launches: Enum.map(article["launches"], fn launch -> build_launches(launch) end),
      events: Enum.map(article["events"], fn event -> build_events(event) end)
    }
  end

  defp build_launches(launch) do
    %{
      external_id: launch["id"],
      provider: launch["provider"]
    }
  end

  defp build_events(event) do
    %{
      external_id: event["id"],
      provider: event["provider"]
    }
  end

  defp notify({:error, error}) do
    MessageSending.new("Erro na consulta API", "Erro: #{error}")
    |> Discord.deliver_async()
  end

  defp notify(_), do: nil
end
