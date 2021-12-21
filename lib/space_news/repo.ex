defmodule SpaceNews.Repo do
  use Ecto.Repo,
    otp_app: :space_news,
    adapter: Ecto.Adapters.Postgres
end
