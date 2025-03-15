require_relative '../lib/freezer'

describe 'Freezer:' do
  let(:freezer) {Freezer.new()}

  describe "#Initialize" do
    it "Allows an instance to be created" do
      expect{Freezer.new()}.not_to raise_error
    end

    it "sets capacity to a default value when not specified" do
      expect(freezer.capacity).to be(100)
    end

    it "allows an explicit capacity to be set" do
      freezer = Freezer.new(200)
      expect(freezer.capacity).to eq(200)
    end

    it "sets the temperature to the ROOM_TEMPERATURE const" do
      expect(freezer.temperature).to eq(Freezer::ROOM_TEMPERATURE)
    end

    it "sets the power to be off" do
      expect(freezer.instance_variable_get(:@power)).to eq(:off)
    end

    it "sets the contents to be empty" do
      expect(freezer.instance_variable_get(:@contents)).to be_empty
    end

    it "has public capacity and temperature fields" do
      expect(freezer).to respond_to(:capacity)
      expect(freezer).to respond_to(:temperature)
    end
  end

  describe "#turn_on" do
    it "turns the power status to on" do
      freezer.turn_on
      expect(freezer.instance_variable_get(:@power)).to be(:on)
    end

    it "does not change the status if already on" do
      freezer.instance_variable_set(:@power, :on)
      freezer.turn_on
      expect(freezer.instance_variable_get(:@power)).to be(:on)
    end
  end

  describe "#turn_off" do
    it "turns the power status to off" do
      freezer.turn_off
      expect(freezer.instance_variable_get(:@power)).to be(:off)
    end

    it "does not change the status if already off" do
      freezer.instance_variable_set(:@power, :off)
      freezer.turn_off
      expect(freezer.instance_variable_get(:@power)).to be(:off)
    end
  end

  describe "#add" do
    it "takes an item and adds it the contents" do
      freezer.add("Test Item")
      expect(freezer.instance_variable_get(:@contents).length).to be(1)
    end

    it "allows duplicate items to be added" do
      another_item = Freezer.new()
      freezer.add(another_item)
      freezer.add(another_item)
      expect(freezer.instance_variable_get(:@contents).length).to be(2)
    end
  end

  describe "#remaining_capacity" do
    it "returns the remaining capacity of its contents" do
      itemFake = double()
      allow(itemFake).to receive(:volume).and_return(7)
      freezer.add(itemFake)
      freezer.add(itemFake)

      expect(freezer.remaining_capacity).to eq(freezer.capacity - 14)
    end

    it "raises an error when items added to the contents do not have a capacity" do
      itemFake = 10
      freezer.add(itemFake)
      freezer.add(itemFake)

      expect {freezer.remaining_capacity}.to raise_error(NoMethodError)
    end
  end

  describe "#set_level" do
    it "sets the temperature to a given level" do
      start_temp = freezer.temperature
      freezer.set_level(6)
      expect(freezer.temperature).to be(10)
    end

    it "doesn't change the temp given a 0 level" do
      start_temp = freezer.temperature
      freezer.set_level(0)
      expect(freezer.temperature).to eq(start_temp)
    end
  end
end
