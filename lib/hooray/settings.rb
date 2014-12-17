module Hooray
  # App settings
  class Settings
    CONFIG_DIR = ENV['HOME'] + '/.hooray/'

    class << self
      attr_accessor :all

      def no_config_folder
        pa "No config folder, run `#{$PROGRAM_NAME} init`", :red
        puts
        exit 1
      end

      def load!
        no_config_folder unless Dir.exist?(CONFIG_DIR)
        @all = YAML.load_file(CONFIG_DIR + 'settings.yml')
        @services = YAML.load_file(CONFIG_DIR + 'services.yml')
        @devices  = YAML.load_file(CONFIG_DIR + 'devices.yml')
        read_mac_prefixes
      end

      def read_mac_prefixes
        @macs = {}
        File.read(CONFIG_DIR + 'nmap-mac-prefixes').each_line do |line|
          next if line =~ /^\s*#/
          prefix, *name = *line.split(/\s/)
          @macs.store(prefix, name.join(' '))
        end
      end

      def list
        out = 'SCAN: '
        out += ' SYN' if syn_scan
        out += ' SERVICE' if service_scan
        out += ' OS' if os_fingerprint
        out
      end

      def device(mac)
        devices[mac.to_sym] || devices[mac.to_s]
      end

      def service(name)
        services[name.to_sym] || services[name.to_s]
      end

      def devices
        @devices ||= {}
      end

      def services
        @services ||= {}
      end

      def manufacturers
        @macs || {}
      end

      def manufacturer(mac)
        prefix = mac.to_s.gsub(':', '')[0, 6].upcase
        manufacturers[prefix]
      end
      alias_method :family, :manufacturer

      def all
        @all ||= {}
      end

      def method_missing(meth, *params)
        if meth =~ /=/
          all[meth.to_s.gsub('=', '')] = params.first
        else
          arg = meth.to_s.gsub('?', '')
          all[arg] || all[arg.to_sym]
        end
      end
    end # class << self
  end # Settings
end # Hooray
