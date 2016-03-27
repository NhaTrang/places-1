class Photo
  include Mongoid::Document
  attr_accessor :id, :location
  attr_writer :contents

  #Shortcut to default database
  def self.mongo_client
  	db = Mongo::Client.new('mongodb://localhost:27017')
  end

  #Initialize instance methods of photo
  def initialize(hash={})
  	@id = hash[:_id].to_s if !hash[:_id].nil?
  	if !hash[:metadata].nil?
  		@location = Point.new(hash[:metadata][:location]) if !hash[:metadata][:location].nil?
  		@place = hash[:metadata][:place]
  	end
  end

  #Checks if instance from GridFS exists
  def persisted?
  	!@id.nil?
  end
end
