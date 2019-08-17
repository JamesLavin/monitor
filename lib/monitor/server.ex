defmodule Monitor.Server do
  use GenServer
  alias Monitor.Impl

  @spec init(any) :: {:ok, any}
  def init(state) do
    {:ok, state}
  end
end
