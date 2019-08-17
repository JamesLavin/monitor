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
end
