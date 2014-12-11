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
      @start = Time.now
    end

    desc 'init', 'creates settings on ~'
    long_desc <<-LONG

    Creates local settings on your home folder.

    LONG
    def init
      return if Dir.exist?(Settings::CONFIG_DIR)
      pa 'Creating ~/.hooray directory', :red
      Dir.mkdir(Settings::CONFIG_DIR)
      settings_dir = File.join(File.dirname(__FILE__), 'settings')
      %w(settings.yml devices.yml services.yml nmap-mac-prefixes).each do |file|
        pa "Creating ~/.hooray/#{file}", :red
        FileUtils.cp "#{settings_dir}/#{file}", Settings::CONFIG_DIR
      end
    end

    desc 'list FILTER', 'list and apply FILTER'
    long_desc <<-LONG

    Lists out all devices connected to the current network.

    LONG
    def list(*filter)
      pa "Listing devices * #{filter}", :red
      print_table Seek.new(options[:network], *filter).nodes
    end

    desc 'watch FILTER', 'watch in realtime  FILTER'
    long_desc <<-LONG

    Keeps listing out all devices connected to the current network.

    LONG
    def watch
      print_table old_seek = Seek.new(options[:network]).nodes
      pa "Starting watch...", :red
      loop do
        sleep 5
        new_seek = Seek.new(options[:network]).nodes
        print_change :new, (new_seek - old_seek)
        print_change :old, (old_seek - new_seek), :red
        old_seek = new_seek
        # binding.pry
      end
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
      Kernel.system 'LANG=en netstat -na | grep "tcp.*LISTEN"'
    end

    private

    def debug(message)
      return unless options[:verbose]
      say message
    end

    def print_change(txt, changes, color = :blue)
      return if changes.empty?
      pa "#{txt.to_s.capitalize} nodes @ #{Time.now}", color
      tp changes, :name, :ip, :mac
    end

    def print_table(nodes)
      tp nodes, :name, :ip, :mac
      puts "---"
      took = (Time.now - @start).round(2)
      pa "#{nodes.count} devices @ #{Time.now} #{took}s", '#777', :bold
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
