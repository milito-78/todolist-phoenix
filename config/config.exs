# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :todolist_api,
  ecto_repos: [TodolistApi.Repo]

# Configures the endpoint
config :todolist_api, TodolistApiWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: TodolistApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: TodolistApi.PubSub,
  live_view: [signing_salt: "K/nCv38F"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :todolist_api, TodolistApi.Mailer,
  adapter: Swoosh.Adapters.SMTP,
  relay: "smtp.mailtrap.io",
  username: "b839efc30f8eb2",
  password: "acb9029582ee31",
  ssl: false,
  tls: :always,
  auth: :always,
  port: 2525,
  retries: 0,
  no_mx_lookups: false

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
