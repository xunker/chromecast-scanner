# Chromecast-scanner

Use it to find Google Chromecast dongles on your local network so you can
send directly to them. Use it in cases where your wireless network has
client isolation enabled and multicast doesn't work.

## Requirements

This script requires Ruby 1.9.3 or higher. It uses only Ruby standard
library calls and does not require any external gems.

## Installation

Either `git clone` the entire repository or simply download `scan.rb`.
On some systems you may need to set the mode on `scan.rb` to make it
directly executable:

```sh
chmod 755 scan.rb
```

## Running

If on a *nix system the file is set as executable (see above), you can
run the program simple with:

```sh
$ ./scan.rb
```

On Windows or other non-*nix system, you can execute the file just as
you would any other ruby script:

```
> ruby scan.rb
```

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
      
    Time to wait for connection (default: 1)

  --read-timeout / -R <seconds>
    
    Time to wait for response (default: 1)

  --help / -h

    Prints this message.

## Example usage

If used with no options, scans all hosts in local class c network, from .1
up to .254.

```sh
$ ./scan.rb
I'm going to scan 1 network segments.
Begining scan of segment 172.16.1.x
172.16.1.1.. execution expired
172.16.1.2.. execution expired
<< snip >>
172.16.1.91.. FOUND!
<< snip >>
172.16.1.253.. execution expired
172.16.1.254.. execution expired
1 Chromecasts found.
172.16.1.91
```

You can optionally specify the network to scan and that start/end hosts.

```sh
$ ./scan.rb --segment 192.168.1 --start 40 --end 41
I'm going to scan 1 network segments.
Begining scan of segment 92.168.1.x
192.168.1.40.. execution expired
192.168.1.41.. FOUND!
1 Chromecasts found.
192.168.1.41
```

You can specify `--segment` multiple times to scan multiple subnets.

## Issues and TODO

* Only scans IPv4 networks, no IPv6 support

## License

Distibuted under WTFPL.
