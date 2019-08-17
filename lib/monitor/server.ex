defmodule Monitor.Server do
  use GenServer
  alias Monitor.Impl

  @spec start_link(any) :: {:ok, pid}
  def start_link(state) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, state, name: {:global, {__MODULE__, node()}})
  end

  @impl true
  @spec init(any) :: {:ok, any}
  def init(state \\ %{}) do
    IO.inspect("Starting monitoring")
    :application.start(:sasl)
    :application.start(:os_mon)
    {:ok, state}
  end

  def mem do
    GenServer.call(monitor_pid(), :mem)
  end

  def mem(pid) when is_pid(pid) do
    GenServer.call(pid, :mem)
  end

  @spec monitor_name :: {:global, {Monitor.Server, atom}}
  def monitor_name do
    {:global, {__MODULE__, node()}}
  end

  @spec global_monitor_name(atom) :: {Monitor.Server, atom}
  def global_monitor_name(node_name) when is_atom(node_name) do
    {__MODULE__, node_name}
  end

  @spec global_monitor_name :: {Monitor.Server, atom}
  def global_monitor_name do
    {__MODULE__, node()}
  end

  @spec monitor_pid(atom) :: :undefined | pid
  def monitor_pid(node_name) when is_atom(node_name) do
    global_monitor_name(node_name) |> :global.whereis_name()
  end

  @spec monitor_pid :: :undefined | pid
  def monitor_pid do
    global_monitor_name() |> :global.whereis_name()
  end

  @impl true
  def handle_call(:mem, _from, state) do
    {:reply, Impl.mem(), state}
  end
end
