module Hooray
  #
  # Socket Port
  #
  class Port < Struct.new(:number, :protocol, :name)
    def name
      @name || Settings.services[number][protocol]
    end
  end
end
