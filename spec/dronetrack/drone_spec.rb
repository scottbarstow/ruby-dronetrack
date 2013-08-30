require 'helper'

describe Dronetrack::Drone do
  
  before(:all) do
    @drone = Drone.new("http://localhost:3000", "111111")
  end  
  
  describe "#all" do
    it "should return all drone records of current user" do
      items = @drone.all
      expect(items.kind_of?(Array)).to be(true)
      expect(items.length).to be >= 0
    end
  end  
end
