class Place
  include Mongoid::Document
  attr_accessor :id, :formatted_address, :location, :address_components

  #Init variables
  def initialize(params={})
    @id = params[:_id].to_s
    @formatted_address = params[:formatted_address]
    @location = Point.new(params[:geometry][:geolocation])
    @address_components = params[:address_components].map{ |a| AddressComponent.new(a)}
  end

  #Shortcut to default database
  def self.mongo_client
  	db = Mongo::Client.new('mongodb://localhost:27017')
  end

  #Returns db collection holding Places
  def self.collection
  	self.mongo_client['places']
  end

  #Loads JSON document and places info into places document
  def self.load_all(file)
  	docs = JSON.parse(file.read)
  	collection.insert_many(docs)
  end

  #Finds collection by short name
  def self.find_by_short_name(short_name)
    collection.find(:'address_components.short_name' => short_name)
  end

  #Returns collection of place objects
  def self.to_places(places)
    places.map do |place|
      Place.new(place)
    end
  end
  
  #Finds instance of place based on id
  def self.find(id)
    id = BSON::ObjectId.from_string(id)
    doc = collection.find(:_id => id).first

    if doc.nil?
      return nil
    else
      return Place.new(doc)
    end
  end

  #Returns collection of all documents as places
  def self.all(offset = 0, limit = nil)
    result = collection.find({}).skip(offset)
    result = result.limit(limit) if !limit.nil?
    result = to_places(result)
  end

  #Delete document
  def destroy
    id = BSON::ObjectId.from_string(@id)
    self.class.collection.delete_one(:_id => id)
  end

end
