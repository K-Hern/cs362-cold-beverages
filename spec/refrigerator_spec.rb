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
      expect { Refrigerator.new(chiller, freezer, water_dispenser, water_reservoir)}.not_to raise_error
    end

    it "Requires the chiller, freezer, water_dispenser, water_reservoir args to create" do
      expect {Refrigerator.new()}.to raise_error(ArgumentError)
    end

    it "sets the power to be off" do
      expect(fridge.instance_variable_get(:@power)).to eq(:off)
    end

    it "has public chiller, freezer, control_panel, water_dispenser, and water_reservoir fields" do
      expect(fridge).to respond_to(:chiller)
      expect(fridge).to respond_to(:freezer)
      expect(fridge).to respond_to(:control_panel)
      expect(fridge).to respond_to(:water_dispenser)
      expect(fridge).to respond_to(:water_reservoir)
    end
  end

  describe "#chill" do
    it "adds the given item to the chiller's contents" do
      fakeItem = double("Banana Item")
      fridge.chill(fakeItem)
      expect(chiller.instance_variable_get(:@contents).length).to eq(1)
    end
  end

  describe "#freeze" do
    it "adds the given item to the freezer's contents" do
      fakeItem = double("Banana Item")
      fridge.freeze(double(fakeItem))
      expect(freezer.instance_variable_get(:@contents).length).to eq(1)
    end
  end

  describe "#total_capacity" do
    it "returns the total capacity of all fridge components" do
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
      level = 6
      fridge.set_chiller_level(level)
      expect(chiller.temperature).to eq(Chiller::ROOM_TEMPERATURE - (level * 5))
    end
  end

  describe "#set_freezer_level" do
    it "sets the level of the freezer to the specified" do
      level = 6
      fridge.set_freezer_level(level)
      expect(freezer.temperature).to eq(Freezer::ROOM_TEMPERATURE - (level * 10))
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
