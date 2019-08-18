use Mix.Config

# For memory-related configuration options, see: http://erlang.org/doc/man/memsup.html
# For disk-related configuration options, see: http://erlang.org/doc/man/disksup.html
# For CPU-related functionality, see: http://erlang.org/doc/man/cpu_sup.html
config :os_mon,
  # memory_check_interval is integer indicating number of minutes
  memory_check_interval: 1,
  system_memory_high_watermark: 0.90,
  process_memory_high_watermark: 0.02,
  # disk_space_check_interval is integer indicating number of minutes
  disk_space_check_interval: 10,
  disk_almost_full_threshold: 0.90
