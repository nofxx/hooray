module Hooray
  # Node representing a device
  class Node
    attr_accessor :host, :name, :nick, :mac, :ip, :ports

    def initialize(params = {})
      self.ip = params[:ip]
      @mac = params[:mac]
      @mac ||= Mac.addr if @ip == Hooray::Local.lan_ip
      @name = params[:name] || find_name
      return unless params[:ports]
      @ports = params[:ports].reject(&:nil?).map { |n| Hooray::Port.new(n) }
    end

    def ip=(param)
      return unless param
      @ip = param.is_a?(IPAddr) ? param : IPAddr.new(param)
    end

    def find_name
      return unless mac
      if [Mac.addr].flatten.include?(mac) # Hack until macaddr get fix
        Socket.gethostname
      else
        Settings.device(mac) || Settings.manufacturer(mac)
      end
    end

    def ports
      @ports.sort.map(&:number).join(', ')
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
