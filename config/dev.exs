import Config

# Configure your database
config :space_news, SpaceNews.Repo,
  username: "postgres",
  password: "postgres",
  database: "space_news_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with esbuild to bundle .js and .css sources.
config :space_news, SpaceNewsWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4001],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "WvvzBO0hQ8XMUHS0E0B382vFi6QkxzXolFZze+s67m3ce6GOFhZkIiUDryd4hbRW",
  watchers: [
    # Start the esbuild watcher by calling Esbuild.install_and_run(:default, args)
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    npx: [
      "tailwindcss",
      "--input=css/app.css",
      "--output=../priv/static/assets/app.css",
      "--postcss",
      "--watch",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

# 12h (UTC) = 09h (UTC -03)
config :space_news, Oban,
  repo: SpaceNews.Repo,
  plugins: [
    {Oban.Plugins.Cron,
     crontab: [
       {"0 12 * * *", SpaceNews.Workers.ImporterSpaceFlightNews}
     ]}
  ],
  queues: [default: 10]

config :space_news, SpaceNews.Discord,
  url: "https://discord.com/api/webhooks",
  webhook_id: "908086774214037535",
  webhook_token: "JFVNdeOLH35TiTqIAW-4X1ORbYdqWSf2IjkBJioRJs4KzhDFMKsdsqxhof062p-ExRAf",
  adapter: SpaceNews.Discord.HTTPAdapter

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :space_news, SpaceNewsWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/space_news_web/(live|views)/.*(ex)$",
      ~r"lib/space_news_web/templates/.*(eex)$"
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime