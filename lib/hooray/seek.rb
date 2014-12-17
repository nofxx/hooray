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
      config_network network
      config_filters params
    end

    def config_network(param)
      if param && !param.empty?
        @network = IPAddr.new(param)
      else
        @network = Hooray::Local.mask
      end
    end

    def config_filters(params)
      return if params.empty?
      params.map! { |o| Settings.service(o) || o }
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
        Node.new(ip: k, mac: Hooray::Local.arp_table[k.to_s], ports: v)
      end.reject { |n| n.mac.nil? } # remove those without mac
    end
    alias_method :devices, :nodes

    #
    # Decide how to ping
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
  end
end
