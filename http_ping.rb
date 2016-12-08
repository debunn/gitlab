require 'net/http'
require 'uri'
require 'benchmark'

# Use the passed URI as a parameter - otherwise use GitLab
if ARGV.empty?
  use_uri = 'https://www.gitlab.com/'
else
  use_uri = ARGV[0]
end

begin
  # Start the program timer, stop after five minutes
  start = Time.now
  time_arr = []

  # Repeat the test until 300 seconds (five minutes) have elapsed
  while (Time.now - start < 300)
    # Benchmark the elapsed time to retrieve the URI, then push in on the array
    response_time = Benchmark.realtime {Net::HTTP.get_response(URI.parse(use_uri))}
    time_arr.push (response_time)
  end

  # Run through all values, determine the average and longest time values
  curr_total = 0
  curr_longest = 0
  time_arr.each do |timeval|
    curr_total += timeval
    timeval > curr_longest ? curr_longest = timeval : true
  end

  # Find the average time, or set to zero if there are no values
  time_arr.length > 0 ? curr_avg = curr_total / time_arr.length : curr_avg = 0

  # Output the average, longest and complete response times
  puts "The average HTTP response time was #{curr_avg.round(3)}s, with " +
  "a longest time of #{curr_longest.round(3)}s.  The complete list of response " +
  "times is as follows:"

  p time_arr

rescue => err
  # Handle any HTTP related errors
  puts "Error encountered: #{err}"
  err
end