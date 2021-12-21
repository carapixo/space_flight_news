defmodule SpaceNews.Discord.Message do
  @derive Jason.Encoder

  defmodule Embed do
    @derive Jason.Encoder

    defmodule Field do
      @derive Jason.Encoder

      defstruct [:name, :value, :inline]
    end

    defstruct [:title, :color, :url, :fields]
  end

  defstruct [:embeds]

  defmacro __using__(_) do
    quote do
      alias SpaceNews.Discord.Message

      def new_message do
        %Message{embeds: []}
      end

      def add_embed(message, attrs, do: block) do
        embed = add_embed(message, attrs)
        block
      end

      def add_embed(message, attrs) do
        embed = %Message.Embed{
          title: Keyword.get(attrs, :title),
          url: Keyword.get(attrs, :url),
          color: Keyword.get(attrs, :color, 375_088),
          fields: []
        }

        %{message | embeds: message.embeds ++ [embed]}
      end

      def add_field(message, attrs) do
        field = %Message.Embed.Field{
          name: Keyword.get(attrs, :name),
          value: Keyword.get(attrs, :value),
          inline: Keyword.get(attrs, :inline, false)
        }

        {last_embed, embeds} = List.pop_at(message.embeds, -1)

        last_embed = %{last_embed | fields: last_embed.fields ++ [field]}

        %{message | embeds: embeds ++ [last_embed]}
      end
    end
  end
end
