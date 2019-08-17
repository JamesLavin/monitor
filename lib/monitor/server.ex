defmodule Monitor.Server do
  use GenServer
  alias Monitor.Impl

  def start_link(state) do
    {:ok, pid} = GenServer.start_link(__MODULE__, state, name: {:global, {__MODULE__, node()}})
  end

  @spec init(any) :: {:ok, any}
  def init(state) do
    {:ok, state}
  end

  def address do
    GenServer.call(__MODULE__, :address)
  end

  @spec monitor_name :: {:global, {Monitor.Server, atom}}
  def monitor_name do
    {:global, {__MODULE__, node()}}
  end

  @spec global_monitor_name :: {Monitor.Server, atom}
  def global_monitor_name do
    {__MODULE__, node()}
  end

  @spec monitor_pid :: :undefined | pid
  def monitor_pid do
    global_monitor_name() |> :global.whereis_name()
  end
end
