class Event
  include Mongoid::Document
	include Mongoid::Timestamps
  field :name, type: String
  field :description, type: String
  field :location, type: String
  field :time, type: Time
	attr_accessible :name, :description, :time, :location
end
