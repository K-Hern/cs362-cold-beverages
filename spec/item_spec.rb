require_relative '../lib/item'

describe 'An item of food or a beverage' do
  describe "#Initialize" do
    it "allows the creation of an instance" do
      expect { Item.new("Test Item", 80) }.not_to raise_error
    end

    it "does not have default values, name and volume are required args" do
      expect { Item.new() }.to raise_error(ArgumentError)
    end

    it "has a name and a volume" do
      item = Item.new("Test Item", 80)

      expect(item.name).to eq("Test Item")
      expect(item.volume).to eq(80)
    end
  end
end
