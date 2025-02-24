# write a script that saves info in a shared kubernetes volume
# the script should save the current date and time every 10 seconds
# the script should run until it is killed

require 'time'

# Get the current date and time
current_time = Time.now.strftime("%Y-%m-%d %H:%M:%S")

# Write the current date and time to a file in the shared volume
File.write("/shared/volume/current_time.txt", current_time)


