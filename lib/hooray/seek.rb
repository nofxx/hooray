module Hooray
  #
  # Main runner
  #
  class Seek
    attr_accessor :network, :ports, :opts

    NET_MASK = 24
    TIMEOUT  = 1

    def initialize(network = nil, *params)
      @scan = {}
      @bots = []
      @network = Seek.local_mask(network)
      return if params.empty?
      numbers, @words = params.flatten.partition { |s| s =~ /\d+/ }
      @ports = numbers.map(&:to_i)
    end

    #
    # Map results to @nodes << Node.new()
    #
    # BUG: sometimes ping returns true
    # When you run list consecutively. Pretty weird!
    # So we need to remove those without mac
    def nodes
      return @nodes if @nodes
      @nodes = sweep.map do |k, v|
        Node.new(ip: k, mac: arp_table[k.to_s], ports: v)
      end.reject { |n| n.mac.nil? } # remove those without mac
    end
    alias_method :devices, :nodes

    def ping_class
      return Net::Ping::External unless ports
      if @words && @words.join =~ /tcp|udp|http|wmi/
        Net::Ping.const_get(@words.join.upcase)
      else
        Net::Ping::TCP
        # elsif (serv = Settings.service(@words.join))
        # @ports = serv.values
      end
    end

    def scan_bot(ip)
      (ports || [nil]).each do |port|
        @bots << Thread.new do
          if ping_class.new(ip.to_s, port, TIMEOUT).ping?
            @scan[ip] << port
            print '.'
          end
        end
      end
    end

    #
    # fast -> -sn -PA
    #
    def sweep
      network.to_range.each do |ip|
        @scan[ip] = []
        scan_bot(ip)
      end
      @bots.each(&:join)
      puts
      @scan.reject! { |_k, v| v.empty? }
    end

    #
    # ARP Table reader
    #
    def arp_table
      return @arp_table if @arp_table
      @arp_table ||= {}
      `arp -na`.split(/\n/).each do |l|
        _q, ip, _at, mac, *iface = l.split(/\s+/)
        next unless mac =~ /:\w{2}:/
        ip = ip[1..-2] # (ip) -> ip
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

      def local_mask(ip)
        if ip && !ip.empty?
          IPAddr.new(ip)
        else
          my_lan_ip.mask(NET_MASK)
        end
      end
    end
  end
end
