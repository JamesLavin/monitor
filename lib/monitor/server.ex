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
    IO.inspect(
      "Starting a Monitor.Server on node #{inspect(node())} with PID #{inspect(monitor_pid())} and name #{
        inspect(monitor_name())
      }"
    )

    :application.start(:sasl)
    :application.start(:os_mon)
    {:ok, state}
  end

  @spec mem :: map()
  def mem do
    GenServer.call(monitor_pid(), :mem)
  end

  @spec mem(pid()) :: map()
  def mem(pid) when is_pid(pid) do
    GenServer.call(pid, :mem)
  end

  @spec sys_mem :: map()
  def sys_mem do
    GenServer.call(monitor_pid(), :sys_mem)
  end

  @spec sys_mem(pid()) :: map()
  def sys_mem(pid) when is_pid(pid) do
    GenServer.call(pid, :sys_mem)
  end

  @spec disk :: map()
  def disk do
    GenServer.call(monitor_pid(), :disk)
  end

  @spec disk(pid()) :: map()
  def disk(pid) when is_pid(pid) do
    GenServer.call(pid, :disk)
  end

  @spec cpu :: map()
  def cpu do
    GenServer.call(monitor_pid(), :cpu)
  end

  @spec cpu(pid()) :: map()
  def cpu(pid) when is_pid(pid) do
    GenServer.call(pid, :cpu)
  end

  @spec unix_procs :: map()
  def unix_procs do
    GenServer.call(monitor_pid(), :unix_procs)
  end

  @spec unix_procs(pid()) :: map()
  def unix_procs(pid) when is_pid(pid) do
    GenServer.call(pid, :unix_procs)
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

  @impl true
  def handle_call(:sys_mem, _from, state) do
    {:reply, Impl.sys_mem(), state}
  end

  @impl true
  def handle_call(:disk, _from, state) do
    {:reply, Impl.disk(), state}
  end

  @impl true
  def handle_call(:cpu, _from, state) do
    {:reply, Impl.cpu(), state}
  end

  @impl true
  def handle_call(:unix_procs, _from, state) do
    {:reply, Impl.num_unix_procs(), state}
  end

  def handle_call(_, _from, state) do
    {:reply, nil, state}
  end

  def handle_cast(_, _from, state) do
    {:noreply, state}
  end
end
