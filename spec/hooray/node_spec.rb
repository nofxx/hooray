require 'spec_helper'

describe 'Node' do

  it 'should have ip' do
    expect(Node.new(ip: '10.1.1.1').ip).to eq('10.1.1.1')
  end

  it 'should have a #to_ip' do
    expect(Node.new(ip: '10.1.1.1').to_ip).to be_a(IPAddr)
  end


  it 'should have mac address' do
    expect(Node.new(mac: 'aa:cc:dd:ee:ff:gg').mac).to eq('aa:cc:dd:ee:ff:gg')
  end

  it 'should have name' do
    expect(Node.new(name: 'my iphone').name).to eq('my iphone')
  end

  it 'should have ports' do

  end

  it 'should have hoops' do

  end

end
