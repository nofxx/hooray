require 'thor'

module Hooray

  # Nice cli
  class CLI < Thor
    class_option :verbose, type: :boolean, aliases: :v
    class_option :network, type: :string, aliases: :n

    def initialize(*args)
      super
      return if ARGV.first =~ /init/
      Settings.load!
    end

    desc 'init', 'creates settings on ~'
    long_desc <<-LONG

    Creates local settings on your home folder.

    LONG
    def init
      return if Dir.exist?(Settings::CONFIG_DIR)
      pa "Creating ~/.hooray directory", :red
      Dir.mkdir(Settings::CONFIG_DIR)
      settings_dir = File.join(File.dirname(__FILE__), 'settings')
      %w{ settings devices services }.each do |file|
        pa "Creating ~/.hooray/#{file}.yml", :red
        FileUtils.cp "#{settings_dir}/#{file}.yml", Settings::CONFIG_DIR
      end
    end


    desc 'list FILTER', 'list and apply FILTER'
    long_desc <<-LONG

    Lists out all devices connected to the current network.

    LONG
    def list(filter = nil)
      pa "Listing devices * #{filter}", :red
      tp Seek.new(options[:network], filter).devices, :name, :ip, :mac
    end


    desc 'watch FILTER', 'watch in realtime  FILTER'
    long_desc <<-LONG

    Keeps listing out all devices connected to the current network.

    LONG
    def watch
    end

    desc 'update', 'updates ssh config files'
    long_desc <<-LONG

    Updates your config files based on devices.

    LONG
    def update
    end

    desc 'update', 'updates ssh config files'
    long_desc <<-LONG

    Updates your config files based on devices.

    LONG
    def update
    end

    desc 'local', 'local port status'
    long_desc <<-LONG

    This is a helper for those who can never remember netstat options.

    LONG
    def local
      Kernel.system 'netstat -na | grep "tcp.*LISTEN"'
    end

    private

    def debug message
      return unless options[:verbose]
      say message
    end

    def method_missing(*params)
      case params.size
      when 1 then
        puts "Do you want to `#{params.first}` to a device?"
        puts "Use #{ARGV.first} #{params.first} <device name>"
      when 2 then
        command, device = *params
        system "#{command} "
      else super
      end
    end
  end
end
