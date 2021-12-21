defmodule SpaceNews.Workers.DeliverDiscordMessageWorker do
  use Oban.Worker, queue: :default, max_attempts: 2

  alias SpaceNews.Discord

  def perform(%{args: %{"message" => message}}) do
    Discord.deliver(message)
  end
end
