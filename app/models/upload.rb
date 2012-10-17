class Upload
  include Mongoid::Document
	include Mongoid::Timestamps
	include Mongoid::Paperclip
  field :name, type: String
	has_mongoid_attached_file :file
	attr_accessible :name, :file
end
