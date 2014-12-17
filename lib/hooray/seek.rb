module Hooray
  #
  # Main runner
  #
  class Seek
    attr_accessor :network, :ports, :opts

    NET_MASK = 24
    TIMEOUT  = 1
    RANGE_REGEX = /\.{2,3}/

    def initialize(network = nil, *params)
      @scan = {}
      @bots = []
      config_network network
      config_filters params
    end

    def config_network(str)
      @network = str && !str.empty? ? IPAddr.new(str) : Hooray::Local.mask
    end

    def config_filters(params)
      return if params.empty?
      # Map services 'foo' -> 3000 udp
      params.map! { |o| Settings.service(o) || o }
      # Map Ranges 1..3 -> [1,2,3]
      params.map! do |o|
        next o unless o =~ RANGE_REGEX
        Range.new(*o.split(RANGE_REGEX)).to_a
      end
      numbers, words = params.flatten.partition { |s| s.to_s =~ /\d+/ }
      @ports, @protocol = numbers.map(&:to_i), words.join
    end

    #
    # Map results to @nodes << Node.new()
    #
    def nodes
      return @nodes if @nodes
      @nodes = sweep.map do |k, v|
        Node.new(ip: k, mac: Hooray::Local.arp_table[k.to_s], ports: v)
      end # .reject { |n| n.mac.nil? } # remove those without mac
    end
    alias_method :devices, :nodes

    #
    # Decide how to ping
    def ping_class
      return Net::Ping::External unless ports
      return Net::Ping::TCP unless @protocol =~ /tcp|udp|http|wmi/
      Net::Ping.const_get(@protocol.upcase)
    end

    #
    # Creates a bot per port on IP
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
      @scan.reject! { |_k, v| v.empty? }
    end

    def to_s
      "Seek #{network} #{ports}"
    end
  end
end
