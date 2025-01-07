# Grover config file
Grover.configure do |config|
  config.options = {
    launch_args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-gpu']
  }
end