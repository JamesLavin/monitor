defmodule Monitor.Impl do
  @spec mem :: %{allocated: number, pct_used: float, total: number, worst_pid: any}
  def mem do
    # NOTE: See http://erlang.org/doc/man/memsup.html for details
    {total, allocated, worst_pid} = :memsup.get_memory_data()
    # mem = [pct_free: mem[:free_memory] / mem[:total_memory]] ++ mem
    # mem = [pct_usage: 1 - mem[:pct_free]] ++ mem
    %{total: total, allocated: allocated, pct_used: allocated / total * 100, worst_pid: worst_pid}
  end

  @spec sys_mem :: %{pct_free: float, pct_used: float, system_pct_free: float}
  def sys_mem do
    # NOTE: See http://erlang.org/doc/man/memsup.html for details
    sys_mem = :memsup.get_system_memory_data() |> Enum.into(%{})
    pct_free = calc_pct_free(sys_mem)
    system_pct_free = calc_system_pct_free(sys_mem)

    sys_mem
    |> Map.put(:pct_free, pct_free)
    |> Map.put(:system_pct_free, system_pct_free)
    |> Map.put(:pct_used, 100 - pct_free)
  end

  defp calc_pct_free(sys_mem) do
    sys_mem[:free_memory] / sys_mem[:total_memory] * 100
  end

  defp calc_system_pct_free(sys_mem) do
    sys_mem[:free_memory] / sys_mem[:system_total_memory] * 100
  end

  def disk do
    :disksup.get_disk_data()
    |> Enum.map(&convert_disk_data/1)
  end

  defp convert_disk_data(disk) do
    {disk_id, total_kbytes, pct_used} = disk

    %{
      disk_id: disk_id |> to_string,
      total_kbytes: total_kbytes |> to_string |> Integer.parse() |> elem(0),
      pct_used: pct_used |> to_string |> Float.parse() |> elem(0)
    }
  end

  @spec cpu :: %{
          cpu_rup_load_15_mins: float,
          cpu_rup_load_1_min: float,
          cpu_rup_load_5_mins: float,
          cpu_usage_pct: number | {:error, any}
        }
  def cpu do
    # NOTE: Disabled cpu_usage_pct_per_core because doesn't seem to provide useful results
    %{
      cpu_usage_pct: :cpu_sup.util(),
      # cpu_usage_pct_per_core:
      #   :cpu_sup.util([:per_cpu, :detailed]) |> Enum.map(&convert_util_desc/1),
      cpu_rup_load_15_mins: :cpu_sup.avg15() / 256,
      cpu_rup_load_5_mins: :cpu_sup.avg5() / 256,
      cpu_rup_load_1_min: :cpu_sup.avg1() / 256
    }
  end

  defp convert_util_desc(desc) do
    desc
    # {cpu_id, busy, free, _unused} = desc
    # %{cpu_id: cpu_id, busy: busy, free: free}
  end

  @spec num_unix_procs :: %{num_unix_procs: integer | {:error, any}}
  def num_unix_procs do
    %{num_unix_procs: :cpu_sup.nprocs()}
  end
end
