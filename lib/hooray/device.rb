module Hooray
  class Device
    attr_accessor :host, :name, :nick, :mac, :ip, :ports

    def initialize(params = {})
      @ip = params[:ip]
      @mac = params[:mac]
      @name = Settings.device(mac)
    end

    def to_ip
      Addrinfo.ip(ip)
    end

  end
end
