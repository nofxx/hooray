module Hooray
  #
  # Main runner
  #
  class Scan < Struct.new(:target, :ports, :opts)
    def run
      scan = []
      bots = []
      pa "Starting #{Settings.list}  on '#{target}' #{ports}"
      [ports].flatten.each do |port|
        bots << Thread.new do
          scan << ip if Net::Ping::TCP.new(ip.to_s, port, 1).ping?
        end
      end
      bots.each(&:join)
      scan
    end
  end
end
