defmodule SpaceNews.Discord.HTTPAdapter do
  use HTTPoison.Base

  def deliver(message) do
    case post("/#{get_env(:webhook_id)}/#{get_env(:webhook_token)}", message) do
      {:ok, _response} -> :ok
      {:error, %HTTPoison.Error{} = error} -> {:error, error.reason}
      _ -> {:error, :unexpected_response}
    end
  end

  @impl true
  def process_request_body(body) do
    Poison.encode!(body)
  end

  @impl true
  def process_request_url(path) do
    get_env(:url) <> path
  end

  @impl true
  def process_request_headers(_headers) do
    [{"Content-Type", "application/json"}]
  end

  defp get_env(key) do
    Application.fetch_env!(:space_news, SpaceNews.Discord) |> Keyword.get(key)
  end
end
