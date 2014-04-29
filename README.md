# Chromecast-scanner

Use it to find Google Chromecast dongles on your local network so you can
send directly to them. Use it in cases where your wireless network has
client isolation enabled and multicast doesn't work.

## Usage
    
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


## Issues and TODO

* Only scans IPv4 networks, no IPv6 support

## License

Distibuted under WTFPL.
