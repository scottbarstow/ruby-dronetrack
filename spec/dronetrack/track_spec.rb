require 'helper'

def create_simple_track
  drone = Drone.new('http://localhost:3000', '111111')
  track = Track.new('http://localhost:3000', '111111')
  d = drone.create :name => 'new Drone'
  item = {:name => 'new Track', :deviceId => d['id']}
  track.create item
end

def create_track
  before (:all) do
      t = create_simple_track
      @trackId = t['id']
      @droneId = t['deviceId']
  end

  after (:all) do
    drone = Drone.new('http://localhost:3000', '111111')
    drone.remove @droneId
  end
end

describe Dronetrack::Track do
  
  before(:all) do
    @track = Track.new('http://localhost:3000', '111111')
  end  
  
  describe '#all' do
    it 'should return all track records of current user' do
      items = @track.all
      expect(items.kind_of?(Array)).to be_true
      expect(items.length).to be >= 0
    end
  end

  describe '#create' do
    it 'should create new track' do
        items = @track.all
        count = items.length
        item = create_simple_track()
        expect(item.has_key?('id')).to be_true
        expect(item['name']).to eq('new Track')
        items = @track.all
        expect(items.length).to eq(count+1)
    end
  end

  describe '#get' do
    it 'should return track with given id' do
        i = create_simple_track()
        item = @track.get i['id']
        expect(item['id']).to eq(i['id'])
        expect(item['name']).to eq(i['name'])
    end

    it 'should fail if track is not exists' do
        expect(lambda {@track.get('id')}).to raise_error
    end
  end

  describe '#update' do
    it 'should update track with given id' do
        i = create_simple_track()
        item = @track.get i['id']
        name=  "Name#{(0...20).map{ ('a'..'z').to_a[rand(26)] }.join}"
        expect(item['name']).to_not eq(name)
        item['name'] = name
        it = @track.update item
        expect(it['name']).to eq name
        it = @track.get i['id']
        expect(it['name']).to eq name
    end

    it 'should fail if track is not exists' do
      item = {:id => 'id', :name => 'Drone'}
      expect(lambda {@track.update item}).to raise_error
    end
  end

  describe '#remove' do
    it 'should remove track with given id' do
        i = create_simple_track()
        items = @track.all
        count = items.length
        @track.remove i['id']
        items = @track.all
        expect(items.length).to be(count-1)
    end

    it 'should fail if track is not exists' do
      expect(lambda {@track.remove 'id'}).to raise_error
    end
  end

  describe '#add_points' do
    create_track()
    it 'should add points' do
      data = [{latitude: 1, longitude: 1}, {latitude: 2, longitude: 2}]
      res = @track.add_points @trackId, data
      expect(res.has_key?('trackId')).to be_true
    end

    it 'should fail for non-existing track' do
      data =  [{latitude: 1, longitude: 1}, {latitude: 2, longitude: 2}]
      expect(lambda {@track.add_points 'id', data}).to raise_error
    end
  end

  describe '#import_points_from_files' do
    create_track()
    it 'should create new tracks and add points for each csv file' do
      files = [File.expand_path('../test1.csv', __FILE__), File.expand_path('../test2.csv', __FILE__)]
      @track.import_points_from_files @trackId, files, :csv
    end

    it 'should create new tracks and add points for each kml file' do
      files = [File.expand_path('../test1.kml', __FILE__)]
      @track.import_points_from_files @trackId, files, :kml
    end
  end

  describe '#get_points' do
    it 'should return points of the track' do
      data = [{latitude: 1, longitude: 1}, {latitude: 2, longitude: 2}]
      @track.add_points @trackId, data
      pts = @track.get_points @trackId
      expect(pts.kind_of?(Array)).to be_true
      expect(pts.length).to be >= 2
    end
  end
end
