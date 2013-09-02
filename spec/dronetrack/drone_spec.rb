require 'helper'

def createDrone
  before (:all) do
    @droneId = @drone.create({:name => 'new Drone'})['id']
  end
  after (:all) do
    @drone.remove @droneId
  end
end


describe Dronetrack::Drone do
  
  before(:all) do
    @drone = Drone.new('http://localhost:3000', '111111')
  end  
  
  describe '#all' do
    it 'should return all drone records of current user' do
      items = @drone.all
      expect(items.kind_of?(Array)).to be_true
      expect(items.length).to be >= 0
    end
  end

  describe '#create' do
    it 'should create new drone' do
        items = @drone.all
        count = items.length
        item = @drone.create :name => 'new Drone'
        expect(item.has_key?('id')).to be_true
        expect(item['name']).to eq('new Drone')
        items = @drone.all
        expect(items.length).to eq(count+1)
    end
  end

  describe '#get' do
    it 'should return drone with given id' do
        i = @drone.create :name => 'new Drone'
        item = @drone.get i['id']
        expect(item['id']).to eq(i['id'])
        expect(item['name']).to eq(i['name'])
    end

    it 'should fail if drone is not exists' do
        expect(lambda {@drone.get('id')}).to raise_error
    end
  end

  describe '#update' do
    it 'should update drone with given id' do
        i = @drone.create :name => 'new Drone'
        item = @drone.get i['id']
        name=  "Name#{(0...20).map{ ('a'..'z').to_a[rand(26)] }.join}"
        expect(item['name']).to_not eq(name)
        item['name'] = name
        it = @drone.update item
        expect(it['name']).to eq name
        it = @drone.get i['id']
        expect(it['name']).to eq name
    end

    it 'should fail if drone is not exists' do
      item = {:id => 'id', :name => 'Drone'}
      expect(lambda {@drone.update item}).to raise_error
    end
  end

  describe '#remove' do
    it 'should remove drone with given id' do
        i = @drone.create :name => 'new Drone'
        items = @drone.all
        count = items.length
        @drone.remove i['id']
        items = @drone.all
        expect(items.length).to be(count-1)
    end

    it 'should fail if drone is not exists' do
      expect(lambda {@drone.remove 'id'}).to raise_error
    end
  end

  describe '#addPoints' do
    createDrone()
    it 'should create new track and add points to it if trackId is missing' do
      data = [{latitude: 1, longitude: 1}, {latitude: 2, longitude: 2}]
      res = @drone.addPoints @droneId, data
      expect(res.has_key?('trackId')).to be_true
    end

    it 'should add points to existing track' do
      data = [{latitude: 1, longitude: 1}, {latitude: 2, longitude: 2}]
      res = @drone.addPoints @droneId, data
      expect(res.has_key?('trackId')).to be_true
      trackId = res['trackId']
      data = [{latitude: 3, longitude: 3}, {latitude: 4, longitude: 4}]
      res = @drone.addPoints @droneId, trackId, data
      expect(res['trackId']).to eq(trackId)
    end

    it 'should fail for non-existing drone' do
      data =  [{latitude: 1, longitude: 1}, {latitude: 2, longitude: 2}]
      expect(lambda {@drone.addPoints 'id', data}).to raise_error
    end

    it 'should fail for non-existing track' do
      data =  [{latitude: 1, longitude: 1}, {latitude: 2, longitude: 2}]
      expect(lambda {@drone.addPoints @droneId, 'trackId',  data}).to raise_error
    end

  end
end
