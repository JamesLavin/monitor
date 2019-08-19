defmodule Monitor.MixProject do
  use Mix.Project

  def project do
    [
      app: :monitor,
      version: "0.1.1",
      elixir: "~> 1.9",
      description:
        "A rudimentary (but hopefully -- eventually -- simple & powerful) API for querying and monitoring the status of servers, server processes, Elixir nodes, and Elixir processes",
      package: package(),
      docs: docs(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Monitor.Application, []}
    ]
  end

  defp deps do
    [
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:recursive_selective_match, "~> 0.2.6", only: [:test]}
    ]
  end

  defp docs do
    [
      extras: ["README.md"]
    ]
  end

  defp package do
    [
      name: "monitor",
      maintainers: ["James Lavin"],
      licenses: ["Apache-2.0"],
      links: %{"Github" => "https://github.com/JamesLavin/monitor"},
      files: ~w(lib .formatter.exs mix.exs README* test)
    ]
  end
end
