module Hooray
  # Node representing a device
  class Node
    attr_accessor :host, :name, :nick, :mac, :ip, :ports

    def initialize(params = {})
      @ip = params[:ip]
      @mac = params[:mac]
      @mac ||= Mac.addr if @ip == Seek.my_lan_ip
      @name = params[:name] || find_name
    end

    def find_name
      return unless mac
      if [Mac.addr].flatten.include?(mac) # Hack until macaddr get fix
        Socket.gethostname
      else
        Settings.device(mac) || Settings.manufacturer(mac)
      end
    end

    def to_ip
      IPAddr.new(ip)
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
