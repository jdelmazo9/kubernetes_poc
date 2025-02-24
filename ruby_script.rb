$stdout.sync = true

current_time = File.read("/shared/volume/current_time.txt")
while true
  # read the current time from the shared volume
  pp "Current time: #{current_time}"

  sleep 20
end
