module Hooray
  #
  # Socket Port
  #
  class Port < Struct.new(:number, :protocol, :name)
    def name
      @name || Settings.services[number][protocol]
    end

    def <=>(other)
      number <=> other.number
    end

    def to_s
      "#{number}/#{protocol}"
    end
  end
end
