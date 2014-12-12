require 'spec_helper'

describe 'Seek' do
  it 'should detect local ip' do
  end

  it 'should search local network' do
  end

  it 'should find nodes' do
  end

  describe 'Query' do

    it 'should default to ICMP without port' do
      expect(Seek.new('').ping_class).to eq(Net::Ping::External)
    end

    it 'should accept ports as integers' do
      expect(Seek.new('', '80').ports).to eq([80])
    end

    it 'should defaults to tcp for ports as integers' do
      expect(Seek.new('', '80').ping_class).to eq(Net::Ping::TCP)
    end

    it 'should accept protocol with port' do
      expect(Seek.new('', '80', 'udp').ping_class).to eq(Net::Ping::UDP)
    end

  end
end
