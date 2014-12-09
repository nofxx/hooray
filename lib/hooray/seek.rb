module Hooray
  #
  # Main runner
  #
  class Seek
    attr_accessor :network, :ports, :opts, :devices

    TMP_FILE = '/tmp/nmap-scan.xml'
    NET_MASK = 24

    def initialize(network = nil, ports = nil, opts = {})
      @devices = []
      @network = network || local_mask
      @devices = discover.map { |h| Device.new(ip: h) }
      @ports = ports
    end

    #
    # fast -> -sn -PA
    #
    def discover
      scan = []
      bots = []
      pa "Starting #{Settings.list}  on '#{network}' #{ports}"
      @network.to_range.each do |ip|
        bots << Thread.new do
          scan << ip if Net::Ping::ICMP.new(ip.to_s, nil, 1).ping?
        end
      end
      bots.each(&:join)
      scan
    end

    def scan(ports)
      scan = []
      bots = []
      pa "Starting #{Settings.list}  on '#{network}' #{ports}"
      @network.to_range.each do |ip|
        bots << Thread.new do
          scan << ip if Net::Ping::TCP.new(ip.to_s, ports, 1).ping?
        end
      end
      bots.each(&:join)
      scan
    end

    def parse
    end

    def find_by_name
    end

    def find_by_port
    end

    def find_by_ip
    end

    def find_by_mac
    end

    def my_ips
      Socket.ip_address_list.select do |ip|
        ip.ipv4_private? && !ip.ipv4_loopback?
      end
    end

    def my_lan_ip
      IPAddr.new(my_ips.first.ip_address)
    end

    def local_mask
      mask = my_lan_ip.mask(NET_MASK)
    end
  end
end
