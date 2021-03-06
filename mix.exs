defmodule Streamr.Mixfile do
  use Mix.Project

  def project do
    [app: :streamr,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Streamr, []},
     applications: [
         :phoenix,
         :phoenix_pubsub,
         :phoenix_html,
         :cowboy,
         :logger,
         :gettext,
         :phoenix_ecto,
         :postgrex,
         :comeonin,
         :ja_serializer,
         :guardian,
         :phoenix_swoosh,
         :swoosh,
         :scrivener_ecto,
         :scrivener,
         :ex_aws,
         :hackney,
         :sweet_xml,
         :timex,
         :timex_ecto,
         :bodyguard
       ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.2.1"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:comeonin, "~> 2.0"},
      {:ja_serializer, "~> 0.11.1"},
      {:guardian, "~> 0.13.0"},
      {:ex_machina, "~> 1.0", only: :test},
      {:cors_plug, "~> 1.1"},
      {:dogma, "~> 0.1", only: :dev},
      {:swoosh,  "~> 0.5.0"},
      {:phoenix_swoosh,  "~> 0.1.3"},
      {:scrivener_ecto, "~> 1.0"},
      {:scrivener, "~> 2.0"},
      {:slugger, "~> 0.1.0"},
      {:ex_aws, "~> 1.0"},
      {:hackney, "~> 1.6.1"},
      {:sweet_xml, "~> 0.6"},
      {:timex, "~> 3.0"},
      {:timex_ecto, "~> 3.0"},
      {:bodyguard, "~> 1.0.0"},
      {:credo, "~> 0.7", only: [:dev, :test]},
      {:joken, "~> 1.1"},
      {:ecto_enum, "~> 1.0"},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
