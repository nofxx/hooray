require 'spec_helper'

describe 'Node' do
  it 'should have ip' do
    expect(Node.new(ip: '10.1.1.1').ip).to eq('10.1.1.1')
  end

  it 'should have a #to_ip' do
    expect(Node.new(ip: '10.1.1.1').ip).to be_a(IPAddr)
  end

  it 'should have mac address' do
    expect(Node.new(mac: 'aa:cc:dd:ee:ff:gg').mac).to eq('aa:cc:dd:ee:ff:gg')
  end

  it 'should have name' do
    expect(Node.new(name: 'my iphone').name).to eq('my iphone')
  end

  it 'should have ports as string' do
    expect(Node.new(ports: [22]).ports).to eq('22')
  end

  it 'should have compare methods' do
    node1 = Node.new(ip: '10.1.1.1')
    node2 = Node.new(ip: '10.1.1.1')
    expect([node1] - [node2]).to be_empty
  end
end
