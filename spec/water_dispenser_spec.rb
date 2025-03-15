require_relative '../lib/water_dispenser'
require_relative '../lib/water_reservoir'

describe 'A water dispenser' do
  describe "#Initialize" do

    it "does not allow the creation of an instance without a reservoir" do
      expect { WaterDispenser.new() }.to raise_error(ArgumentError)
    end

    it "allows the creation of an instance" do
      expect { WaterDispenser.new(double('FakeReservoir')) }.to_not raise_error
    end

    it "has a reservoir field" do
      expect(WaterDispenser.new(double('FakeReservoir'))).to respond_to(:reservoir)
    end
  end

  describe "#dispense" do
    let(:wr) {WaterReservoir.new()}
    let(:wd) {WaterDispenser.new(wr)}

    it "does not allows the dispensing of more than available" do
      wd.dispense(double('fakeVessel', volume: 11))
      expect(wr.current_water_volume).to eq(10)
    end

    it "dispenses the given amount if not excessive & refills" do
      wd.dispense(double('fakeVessel', volume: 10))
      expect(wr.current_water_volume).to eq(10)

      wr.current_water_volume = 10
      wd.dispense(double('fakeVessel', volume: 4))
      expect(wr.current_water_volume).to eq(10)
    end
  end
end
