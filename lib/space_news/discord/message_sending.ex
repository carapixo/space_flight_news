defmodule SpaceNews.Discord.MessageSending do
  use SpaceNews.Discord.Message

  def new(title, message) do
    new_message()
    |> add_embed(title: title)
    |> add_field(
      name: "Message",
      value: message
    )
    |> add_field(
      name: "Date",
      value: Timex.now() |> Timex.to_datetime("America/Sao_Paulo") |> Timex.format!("{RFC1123}")
    )
  end
end
