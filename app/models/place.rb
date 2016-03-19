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

end
