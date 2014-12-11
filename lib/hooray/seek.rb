module Hooray
  #
  # Main runner
  #
  class Seek
    attr_accessor :network, :opts, :nodes

    NET_MASK = 24
    TIMEOUT  = 1

    def initialize(network = nil, *params)
      @network = network || Seek.local_mask
      unless params.empty?
        ports, words = params.flatten.partition { |s| s =~ /\d+/ }
        @ports = ports.map(&:to_i).first # TODO
        @protocol = words.select { |w| w =~ /udp|tcp/ }.join
      end

      @nodes = ping.sort.map do |n|
        Node.new(ip: n, mac: arp_table[n.to_s]) # , name: find_name(n))
      end
    end

    def ping_class
      return Net::Ping::External unless @protocol
      @protocol =~ /udp/ ? Net::Ping::UDP : Net::Ping::TCP
    end

    #
    # fast -> -sn -PA
    #
    def ping
      scan = []
      bots = []
      # pa "Starting #{Settings.list} on '#{network}' #{@ports} #{@protocol}"
      @network.to_range.each do |ip|
        # next if ip == my_lan_ip
        bots << Thread.new do
          if ping_class.new(ip.to_s, @ports, TIMEOUT).ping?
            scan << ip
            print '.'
          end
        end
      end
      bots.each(&:join)
      puts
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

    class << self

    def my_ips
      Socket.ip_address_list.select do |ip|
        ip.ipv4_private? && !ip.ipv4_loopback?
      end
    end

    def my_lan_ip
      IPAddr.new(my_ips.first.ip_address)
    end

    def local_mask
      my_lan_ip.mask(NET_MASK)
    end
    end
  end
end
