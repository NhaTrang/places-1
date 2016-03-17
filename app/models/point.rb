class Point
  attr_accessor :longitude, :latitude

  #initialize Point class
  def initialize(params)
    @longitude = hash[:lng]
    @latitude = hash[:lat]
  end

end
