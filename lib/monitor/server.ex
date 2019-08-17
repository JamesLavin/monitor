defmodule Monitor.Server do
  use GenServer
  alias Monitor.Impl

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @spec init(any) :: {:ok, any}
  def init(state) do
    {:ok, state}
  end
end
