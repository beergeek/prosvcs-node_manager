require 'puppet'
require 'puppet/type/node_group'

type_class = Puppet::Type.type(:node_group)
describe type_class do

  it 'should not allow special characters in the name' do
    expect {
      type_class.new({
        :name    => '+++',
        :classes => {},
      })
    }.to raise_error /\+\+\+ is not a valid group name/
  end

  it 'should not accept an id attribute' do
    expect {
      type_class.new({
        :name    => 'fail group',
        :id      => '1',
        :classes => {},
      })
    }.to raise_error /ID is read-only/
  end

  it 'should only accept boolean for override_environment' do
    expect {
      type_class.new({
        :name                 => 'fail group',
        :override_environment => 'string',
        :classes              => {},
      })
    }.to raise_error /Valid values are false, true./
  end

  it 'should only accept a hash for variables' do
    expect {
      type_class.new({
        :name      => 'fail group',
        :classes   => {},
        :variables => 'string',
      })
    }.to raise_error /Variables must be supplied as a hash/
  end

  it 'should only accept a hash for classes' do
    expect {
      type_class.new({
        :name    => 'fail group',
        :classes => 'string',
      })
    }.to raise_error /Classes must be supplied as a hash/
  end

  context 'using default attributes' do
    before :each do
      @node_group = type_class.new(
        :name   => 'asterix',
        :ensure => 'present',
      )
    end

    it 'should have a default parent of default' do
      expect(@node_group[:parent]).to eq(:default)
    end

    it 'should have a default environment of production' do
      expect(@node_group[:environment]).to eq(:production)
    end

    it 'should have a default classes of nil' do
      expect(@node_group[:classes]).to eq(nil)
    end

  end

end
