defmodule SpaceNews.Workers.ImporterSpaceFlightNews do
  use Oban.Worker, queue: :default, max_attempts: 3

  alias SpaceNews.Discord
  alias SpaceNews.Discord.MessageSending
  alias SpaceNews.SpaceFlight.SpaceFlightAPI

  @impl Oban.Worker
  def perform(_) do
    case SpaceFlightAPI.import() do
      {:error, _reason} = error ->
        {:error, error}
        |> notify()

      _result ->
        :ok
    end
  end

  defp notify({:error, error}) do
    MessageSending.new("Erro na consulta API", "Erro: #{error}")
    |> Discord.deliver_async()
  end

  defp notify(_), do: nil
end
