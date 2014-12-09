module Hooray
  class Node
    attr_accessor :host, :name, :nick, :mac, :ip, :ports

    def initialize(params = {})
      @ip = params[:ip]
      @mac = params[:mac]
      @name = Settings.device(mac) if mac
    end

    def to_ip
      Addrinfo.ip(ip)
    end

    def <=>(other)
      self.ip <=> other.ip
    end
  end
end
