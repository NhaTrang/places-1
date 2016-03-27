class Photo
  include Mongoid::Document

  #Shortcut to default database
  def self.mongo_client
  	db = Mongo::Client.new('mongodb://localhost:27017')
  end
end
