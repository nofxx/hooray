module Hooray
  #
  # Information from the machine
  #
  class Local
    class << self
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

      def ips
        Socket.ip_address_list.select do |ip|
          ip.ipv4_private? && !ip.ipv4_loopback?
        end
      end

      def lan_ip
        IPAddr.new(ips.first.ip_address)
      end

      def mask(bits = 24)
        lan_ip.mask(bits)
      end
    end
  end
end
