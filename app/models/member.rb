class Member
  include Mongoid::Document
	include Mongoid::Paperclip
	include Mongoid::Timestamps

	belongs_to :user

  field :name, type: String
  field :description, type: String
  field :tags, type: String
	field :discount, type: String
	field :type, type: String

	has_mongoid_attached_file :image, :styles => { :thumb => '135x75>', :large => '200X' }
	attr_accessible :name, :description, :tags, :image, :discount, :discount
end
