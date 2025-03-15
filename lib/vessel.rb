class Vessel
  attr_reader :volume, :name

  def initialize(name = 'FAKE', volume = 100)
    @name = name
    @volume = volume
    @contentsVolume = 0
  end

  def empty?()
    return (@contentsVolume == 0)
  end

  def fill()
    @contentsVolume = @volume
  end
end
