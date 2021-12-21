defmodule SpaceNews.Repo.Migrations.AddPgcryptoExtensions do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS pgcrypto;"
  end

  def down do
    execute "DROP EXTENSION IF EXISTS pgcrypto;"
  end
end
