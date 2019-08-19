# Monitor

Monitor provides a rudimentary (but hopefully -- eventually -- simple yet powerful) API
for querying and monitoring the status of servers, server processes,
Elixir nodes, and Elixir processes.

The Monitor runs as a supervised GenServer, so if it crashes, it should
get automatically restarted and its new PID associated with its `:global`
name, which looks something like `{Monitor.Server, :"node@server"}`.

## Usage

To start up one or more Elixir nodes running `Monitor`:

```elixir
iex --name "m1@127.0.0.1" -S mix
```

When the node starts up, it will start a `Monitor.Server` instance on the node and output a message like:

```elixir
"Starting a Monitor.Server on node :\"m1@127.0.0.1\" with PID #PID<0.182.0> and name {:global, {Monitor.Server, :\"m1@127.0.0.1\"}}"

```

### Finding the server's :global name & PID

To find the PID of the `Monitor.Server` on the local node:

```elixir
{Monitor.Server, node()} |> :global.whereis_name()
```

or

```elixir
Monitor.Server.monitor_pid()
```

To find the PID of the `Monitor.Server` on a named node:

```elixir
{Monitor.Server, :"m2@127.0.0.1"} |> :global.whereis_name()
```

or

```elixir
:"m2@127.0.0.1" |> Monitor.Server.monitor_pid()
```

### Memory usage

To look up the current node's memory usage:

```elixir
Monitor.Server.mem
```

To look up a specific node's memory usage:

```elixir
node() |> Monitor.Server.monitor_pid |> Monitor.Server.mem
```

This should return output like:

```
%{
  allocated: 22520721408,
  pct_used: 67.07508261746172,
  total: 33575391232,
  worst_pid: {#PID<0.195.0>, 372624}
}
```

### System memory usage

To look up the current node's system memory usage:

```elixir
Monitor.Server.sys_mem
```

To look up a specific node's system memory usage:

```elixir
node() |> Monitor.Server.monitor_pid |> Monitor.Server.sys_mem
```

This should return output like:

```
%{
  buffered_memory: 1577607168,
  cached_memory: 9958359040,
  free_memory: 11125661696,
  free_swap: 0,
  pct_free: 33.1363575754744,
  pct_used: 66.86364242452561,
  system_pct_free: 33.1363575754744,
  system_total_memory: 33575391232,
  total_memory: 33575391232,
  total_swap: 0
}
```

### Disk usage

To look up the current node's disk usage:

```elixir
Monitor.Server.disk
```

To look up a specific node's disk usage:

```elixir
node() |> Monitor.Server.monitor_pid |> Monitor.Server.disk
```

This should return output like:

```
[
  %{disk_id: "/dev", pct_used: 0.0, total_kbytes: 16363208},
  %{disk_id: "/run", pct_used: 1.0, total_kbytes: 3278848},
  %{disk_id: "/", pct_used: 88.0, total_kbytes: 980675660},
  ...
]
```

### CPU usage

To look up the current node's CPU usage:

```elixir
Monitor.Server.cpu
```

To look up a specific node's CPU usage:

```elixir
node() |> Monitor.Server.monitor_pid |> Monitor.Server.cpu
```

This should return output like:

```
%{
  cpu_rup_load_15_mins: 0.890625,
  cpu_rup_load_1_min: 1.0390625,
  cpu_rup_load_5_mins: 0.7890625,
  cpu_usage_pct: 27.03737166435444
}
```

### Unix processes

To look up the current node's number of Unix processes:

```elixir
Monitor.Server.unix_procs
```

To look up a specific node's number of Unix processes:

```elixir
node() |> Monitor.Server.monitor_pid |> Monitor.Server.unix_procs
```

This should return output like:

```
%{num_unix_procs: 2399}
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `monitor` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:monitor, "~> 0.1.1"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/monitor](https://hexdocs.pm/monitor).
