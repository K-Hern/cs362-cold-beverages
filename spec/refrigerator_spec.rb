require_relative '../lib/refrigerator'
require_relative '../lib/freezer'
require_relative '../lib/chiller'
require_relative '../lib/water_reservoir'
require_relative '../lib/water_dispenser'

describe 'Refrigerator:' do
  let(:freezer) { Freezer.new() }
  let(:chiller) { Chiller.new() }
  let(:water_reservoir) { WaterReservoir.new() }
  let(:water_dispenser) { WaterDispenser.new(water_reservoir) }
  let(:fridge) { Refrigerator.new(chiller, freezer, water_dispenser, water_reservoir) }

  describe "#Initialize" do
    it "Allows an instance to be created" do
      expect{Refrigerator.new("chiller", "freezer", "water Dispenser", "Water Reservoir")}.not_to raise_error
    end

    it "sets the power to be off" do
      expect(fridge.instance_variable_get(:@power)).to eq(:off)
    end
  end

  describe "#chill" do
    it "adds the given item to the chiller's contents" do
      fridge.chill("An Item")
      expect((fridge.chiller.instance_variable_get(:@contents)).length).to eq(1)
    end
  end

  describe "#freeze" do
    it "adds the given item to the freezer's contents" do
      fridge.freeze("An Item")
      expect((fridge.freezer.instance_variable_get(:@contents)).length).to eq(1)
    end
  end

  describe "#total_capacity" do
    it "returns the total capacity of fridge components" do
      expect(fridge.total_capacity).to eq(freezer.capacity + chiller.capacity)
    end
  end

  describe "#remaining_capacity" do
    it "returns the sum of all components remaining capacity" do
      expect(fridge.remaining_capacity).to eq(freezer.remaining_capacity + chiller.remaining_capacity)
    end
  end

  describe "#plug_in" do
    it "sets the power status of all components, including itself to on" do
      fridge.plug_in
      expect(fridge.instance_variable_get(:@power)).to eq(:on)
      expect(freezer.instance_variable_get(:@power)).to be(:on)
      expect(chiller.instance_variable_get(:@power)).to be(:on)
    end
  end

  describe "#unplug" do
    it "sets the power status of all components, including itself to off" do
      fridge.unplug
      expect(fridge.instance_variable_get(:@power)).to eq(:off)
      expect(freezer.instance_variable_get(:@power)).to be(:off)
      expect(chiller.instance_variable_get(:@power)).to be(:off)
    end
  end

  describe "#set_chiller_level" do
    it "sets the level of the chiller to the specified" do
      fridge.set_chiller_level(6)
      expect(chiller.temperature).to eq(40)
    end
  end

  describe "#set_freezer_level" do
    it "sets the level of the freezer to the specified" do
      fridge.set_freezer_level(6)
      expect(freezer.temperature).to eq(10)
    end
  end

  describe "#to_s" do
    let(:string_output) {fridge.to_s}

    it "prints the power status" do
      expect(string_output).to include("Power: #{fridge.instance_variable_get(:@power)}")
    end

    it "prints the both the current and remaining capacity" do
      expect(string_output).to include("Storage: #{fridge.remaining_capacity} of #{fridge.total_capacity} available")
    end

    it "prints the temperature of components" do
      expect(string_output).to include("Temps: Chiller is #{chiller.temperature}, Freezer is #{freezer.temperature}")
    end

    it "prints the water capacity" do
      expect(string_output).to include("Water: Reservoir has #{water_reservoir.current_water_volume} remaining.")
    end
  end
end
