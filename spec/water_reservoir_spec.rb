require_relative '../lib/water_reservoir'

describe 'A Water Reservoir:' do
  let(:wr) {WaterReservoir.new()}

  describe "#Initialize" do

    it "allows an instance to be created" do
      expect{WaterReservoir.new()}.not_to raise_error
    end

    it "has a capacity and volume with default values" do
      expect(wr.capacity).to eq(10)
      expect(wr.current_water_volume).to eq(0)
    end

    it "allows specified values to be set on creation" do
      wr = WaterReservoir.new(20, 5)
      expect(wr.capacity).to eq(20)
      expect(wr.current_water_volume).to eq(5)
    end
  end

  describe "#empty?" do
    it "doesn't read empty after a fill" do
      wr.current_water_volume = 10
      expect(wr).not_to be_empty
    end

    it "is empty when it has a content volume of 0" do
      expect(wr.current_water_volume).to eq(0)
      expect(wr).to be_empty
    end

    it "reads empty after it has been emptied" do
      wr.current_water_volume = 10
      wr.current_water_volume = 0
      expect(wr).to be_empty
    end
  end

  describe "#fill" do
    it "completely fills the capacity" do
      wr.fill()
      expect(wr.current_water_volume).to eq(wr.capacity)
    end
  end

  describe "#drain" do
    it "decreases the current volume when drained by the given amount" do
      wr.current_water_volume = 10
      wr.drain(7)
      expect(wr.current_water_volume).to eq(3)
    end

    it "does not change the capacity when a 0 volume is given" do
      wr.current_water_volume = 10
      wr.drain(0)
      expect(wr.current_water_volume).to eq(10)
    end

    it "does not drain when the given amount is more than available" do
      wr.current_water_volume = 10
      wr.drain(20)
      expect(wr.current_water_volume = 10)
    end

    it "drains when the given amount is equal to the available" do
      wr.current_water_volume = 10
      wr.drain(10)
      expect(wr.current_water_volume = 0)
    end
  end
end
