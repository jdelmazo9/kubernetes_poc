$stdout.sync = true

require 'time'

while true
  sleep 60

  one_year_ago = Time.now - (365 * 24 * 60 * 60)
  one_year_later = Time.now + (365 * 24 * 60 * 60)

  File.write("/shared/volume/current_time.txt", [one_year_ago, one_year_later].sample.strftime("%Y-%m-%d %H:%M:%S"))

  # restart the worker
  # Find the PID
  pid = `ps aux | grep "ruby ruby_script.rb" | grep -v grep | awk '{print $2}'`.strip

  if pid.empty?
    puts "Process not found"
  else
    puts "Found process with PID: #{pid}"
    # Kill gracefully (SIGTERM)
    Process.kill("TERM", pid.to_i)
  end
end
