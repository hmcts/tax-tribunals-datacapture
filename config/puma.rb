# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
port ENV.fetch("PORT", 3000)

environment ENV.fetch("RAILS_ENV", "development")

pids_dir = "tmp/pids"
FileUtils.mkdir_p(pids_dir)

# Specifies the `pidfile` that Puma will use.
pidfile ENV.fetch("PIDFILE", "tmp/pids/server.pid")

# Run the Solid Queue supervisor inside of Puma for single-server deployments
# plugin :solid_queue if ENV["SOLID_QUEUE_IN_PUMA"]

# Allow puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart
