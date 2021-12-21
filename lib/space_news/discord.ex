defmodule SpaceNews.Discord do
  alias SpaceNews.Discord.HTTPAdapter
  alias SpaceNews.Workers.DeliverDiscordMessageWorker

  def deliver(message), do: HTTPAdapter.deliver(message)

  def deliver_async(message) do
    %{message: message}
    |> DeliverDiscordMessageWorker.new()
    |> Oban.insert()
  end
end
