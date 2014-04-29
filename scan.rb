#!/usr/bin/env ruby

MINIMUM_RUBY_VERSION = "1.9.3"

if RUBY_VERSION.to_f < MINIMUM_RUBY_VERSION.to_f
  puts [
    "This program requires ruby",
    MINIMUM_RUBY_VERSION,
    "or higher, but was run using",
    RUBY_VERSION
  ].join(' ')
  exit
end

require 'net/http'
require 'open-uri'

require 'getoptlong'

opts = GetoptLong.new(
  [ '--segment', '-S', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--start', '-s', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--end', '-e', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--open-timeout', '-O', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--read-timeout', '-R', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ]
)

class_c_networks = []
host_scan_start = 1
host_scan_end = 254

$open_timeout = 1
$read_timeout = 1

opts.each do |opt, arg|
  case opt
  when '--help'
    usage = <<-EOF

scan.rb [OPTION]

--segment / -S <class c>

  Specify the class c network secgment to scan. Expects a format
  like this: 172.16.1

--start / -s <number>

  The host on which to start the scan in the given class c.

--end / -e <number>

  The host on which to end the scan in the given class c.

--open-timeout / -O <seconds>
    
  Time to wait for connection (default: #{$open_timeout})

--read-timeout / -R <seconds>
  
  Time to wait for response (default: #{$read_timeout})

--help / -h

  Prints this message.

    EOF
    puts(usage)
    exit
  when '--segment'
    class_c_networks << arg
  when '--start'
    host_scan_start = arg.to_i
  when '--end'
    host_scan_end = arg.to_i
  when '--open-timeout'
    open_timeout = arg.to_i
  when '--read-timeout'
    read_timeout = arg.to_i
  end
end

if class_c_networks.empty?
  require 'socket'

  local_addresses = Socket.ip_address_list.
    select(&:ipv4?).
    reject(&:ipv4_loopback?).
    map(&:ip_address)

  class_c_networks = local_addresses.map{|ip| ip.split('.')[0..2].join('.') }.uniq
end

found = []

def chromecast_found?(ip_address)
  http = Net::HTTP.start(
    ip_address, 8008,
    { :read_timeout => $read_timeout, :open_timeout => $open_timeout }
  )
  res = http.get('/apps', { 'Accepts' => 'application/xml', 'Content-Type' => 'application/xml' })
  case res.code.to_i
  when 302
    return true
  else
    return false
  end
rescue Errno::ECONNREFUSED, Net::OpenTimeout, Timeout::Error, Errno::EHOSTDOWN, Errno::EHOSTUNREACH => e
  puts e
  return false
end

puts "I'm going to scan #{class_c_networks.size} network segments."
class_c_networks.each do |class_c|
  puts "Begining scan of segment #{class_c}.x"
  host_scan_start.upto(host_scan_end).each do |station|
    host_ip = [ class_c, station ].join('.')
    print "#{host_ip}.. "
    if chromecast_found?(host_ip)
      puts "FOUND!"
      found << host_ip
    end
  end
end

puts "#{found.length} Chromecasts found."
found.each do |ip|
  puts ip
end
