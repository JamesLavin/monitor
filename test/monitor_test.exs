defmodule MonitorTest do
  use ExUnit.Case
  doctest Monitor
  alias RecursiveSelectiveMatch, as: RSM

  test "a Monitor.Server returns memory information" do
    mem = Monitor.Server.mem()

    expected = %{
      allocated: :any_pos_integer,
      pct_used: :any_non_neg_float,
      total: :any_pos_integer,
      worst_pid: {:any_pid, :any_pos_integer}
    }

    assert RSM.matches?(expected, mem)
  end

  test "a Monitor.Server returns sys_memory information" do
    sys_mem = Monitor.Server.sys_mem()

    expected = %{
      buffered_memory: :any_pos_integer,
      cached_memory: :any_non_neg_integer,
      free_memory: :any_non_neg_integer,
      free_swap: :any_non_neg_integer,
      pct_free: &valid_percentage/1,
      pct_used: &valid_percentage/1,
      system_pct_free: &valid_percentage/1,
      system_total_memory: :any_pos_integer,
      total_memory: :any_pos_integer,
      total_swap: :any_non_neg_integer
    }

    assert RSM.matches?(expected, sys_mem)
  end

  test "a Monitor.Server returns disk information" do
    disk = Monitor.Server.disk()

    expected = %{
      disk_id: &Regex.match?(~r/\/.*/, &1),
      pct_used: &valid_percentage/1,
      total_kbytes: :any_pos_integer
    }

    assert RSM.includes?(expected, disk)
  end

  test "a Monitor.Server returns CPU information" do
    cpu = Monitor.Server.cpu()

    expected = %{
      cpu_rup_load_15_mins: :any_non_neg_float,
      cpu_rup_load_1_min: :any_non_neg_float,
      cpu_rup_load_5_mins: :any_non_neg_float,
      cpu_usage_pct: &valid_percentage/1
    }

    assert RSM.matches?(expected, cpu)
  end

  test "a Monitor.Server returns Unix processes information" do
    unix_procs = Monitor.Server.unix_procs()

    expected = %{
      num_unix_procs: :any_pos_integer
    }

    assert RSM.matches?(expected, unix_procs)
  end

  defp valid_percentage(val) do
    is_float(val) && val >= 0 && val <= 100
  end
end
