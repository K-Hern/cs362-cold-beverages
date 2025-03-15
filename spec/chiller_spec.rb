require_relative '../lib/chiller'

describe 'Chiller:' do
  let(:chiller) {Chiller.new()}

  describe "#Initialize" do
    it "Allows an instance to be created" do
      expect{Chiller.new()}.not_to raise_error
    end

    it "sets capacity to a default value when not specified" do
      expect(chiller.capacity).to be(100)
    end

    it "allows an explicit capacity to be set" do
      chiller = Chiller.new(200)
      expect(chiller.capacity).to eq(200)
    end

    it "sets the temperature to the ROOM_TEMPERATURE const" do
      expect(chiller.temperature).to eq(Chiller::ROOM_TEMPERATURE)
    end

    it "sets the power to be off" do
      expect(chiller.instance_variable_get(:@power)).to eq(:off)
    end

    it "sets the contents to be empty" do
      expect(chiller.instance_variable_get(:@contents)).to be_empty
    end

    it "has public capacity and temperature fields" do
      expect(chiller).to respond_to(:capacity)
      expect(chiller).to respond_to(:temperature)
    end
  end

  describe "#turn_on" do
    it "turns the power status to on" do
      chiller.turn_on
      expect(chiller.instance_variable_get(:@power)).to be(:on)
    end

    it "does not change the status if already on" do
      chiller.instance_variable_set(:@power, :on)
      chiller.turn_on
      expect(chiller.instance_variable_get(:@power)).to be(:on)
    end
  end

  describe "#turn_off" do
    it "turns the power status to off" do
      chiller.turn_off
      expect(chiller.instance_variable_get(:@power)).to be(:off)
    end

    it "does not change the status if already off" do
      chiller.instance_variable_set(:@power, :off)
      chiller.turn_off
      expect(chiller.instance_variable_get(:@power)).to be(:off)
    end
  end

  describe "#add" do
    it "takes an item and adds it the contents" do
      chiller.add("Test Item")
      expect(chiller.instance_variable_get(:@contents).length).to be(1)
    end

    it "allows duplicate items to be added" do
      another_item = Chiller.new()
      chiller.add(another_item)
      chiller.add(another_item)
      expect(chiller.instance_variable_get(:@contents).length).to be(2)
    end
  end

  describe "#remaining_capacity" do
    it "returns the remaining capacity of its contents" do
      itemFake = double()
      allow(itemFake).to receive(:volume).and_return(7)
      chiller.add(itemFake)
      chiller.add(itemFake)

      expect(chiller.remaining_capacity).to eq(chiller.capacity - 14)
    end

    it "raises an error when items added to the contents do not have a capacity" do
      itemFake = 10
      chiller.add(itemFake)
      chiller.add(itemFake)

      expect {chiller.remaining_capacity}.to raise_error(NoMethodError)
    end
  end

  describe "#set_level" do
    it "sets the temperature to a given level" do
      start_temp = chiller.temperature
      chiller.set_level(6)
      expect(chiller.temperature).to be(40)
    end

    it "doesn't change the temp given a 0 level" do
      start_temp = chiller.temperature
      chiller.set_level(0)
      expect(chiller.temperature).to eq(start_temp)
    end
  end
end
