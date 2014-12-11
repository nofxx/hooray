module Hooray
  # Node representing a device
  class Node
    attr_accessor :host, :name, :nick, :mac, :ip, :ports

    def initialize(params = {})
      @ip = params[:ip]
      @mac = params[:mac]
      @mac ||= Mac.addr if @ip == Seek.my_lan_ip
      set_name
    end

    def set_name
      return unless mac
      if [Mac.addr].flatten.include?(mac)
        @name = Socket.gethostname
      else
        @name = Settings.device(mac) || Settings.family(mac)
      end
    end

    def to_ip
      Addrinfo.ip(ip)
    end

    def <=>(other)
      ip <=> other.ip
    end

    def eql?(other)
      ip == other.ip || mac == other.mac
    end

    def hash
      [ip, mac].hash
    end
  end
end
