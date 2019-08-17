defmodule Monitor.Impl do
  @spec mem :: [
          {:allocated, number} | {:pct_used, float} | {:total, number} | {:worst_pid, any},
          ...
        ]
  def mem do
    {total, allocated, worst_pid} = :memsup.get_memory_data()
    # mem = [pct_free: mem[:free_memory] / mem[:total_memory]] ++ mem
    # mem = [pct_usage: 1 - mem[:pct_free]] ++ mem
    [total: total, allocated: allocated, pct_used: allocated / total * 100, worst_pid: worst_pid]
  end
end
