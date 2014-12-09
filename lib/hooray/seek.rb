module Hooray
  #
  # Main runner
  #
  class Seek
    attr_accessor :network, :service, :opts, :devices

    TMP_FILE = '/tmp/nmap-scan.xml'
    NET_MASK = 24
    TIMEOUT  = 1

    def initialize(network = nil, service = nil,  opts = {})
      @network = network || local_mask
      @service = service

      @devices = ping.sort.map do |n|

        Device.new(ip: n, mac: arp_table[n.to_s]) #, name: find_name(n))
      end
    end

    def ping_class
      return Net::Ping::External unless service
      service.keys.join =~ /udp/ ? Net::Ping::UDP : Net::Ping::TCP
    end

    #
    # fast -> -sn -PA
    #
    def ping
      scan = []
      bots = []
      pa "Starting #{Settings.list}  on '#{network}' #{service}"
      @network.to_range.each do |ip|
        bots << Thread.new do
          scan << ip if ping_class.new(ip.to_s, service, TIMEOUT).ping?
        end
      end
      bots.each(&:join)
      scan
    end

    def arp_table
      return @arp_table if @arp_table
      @arp_table ||= {}
      `arp -n`.split(/\n/).each do |l|
        ip, _hw, mac, _flag, iface = l.split(/\s+/)
        # p "#{ip}  #{mac} #{iface}"
        @arp_table.merge!(ip => mac) if iface
      end
      @arp_table
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
