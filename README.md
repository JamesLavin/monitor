# Monitor

Monitor provides a simple (but hopefully -- eventually -- powerful) API
for querying and monitoring the status of servers, server processes,
Elixir nodes, and Elixir process.

The Monitor runs as a supervised GenServer, so if it crashes, it should
get automatically restarted and its new PID associated with its `:global`
name, `Monitor.Server`.

## Usage

To start up one or more Elixir nodes running `Monitor`:

```elixir
iex --name "m1@127.0.0.1" -S mix
```

To find the PID of the `Monitor.Server` on the local node:

```elixir
{Monitor.Server, node()} |> :global.whereis_name()
```

To find the PID of the `Monitor.Server` on a named node:

```elixir
{Monitor.Server, :"m2@127.0.0.1"} |> :global.whereis_name()
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `monitor` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:monitor, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/monitor](https://hexdocs.pm/monitor).
