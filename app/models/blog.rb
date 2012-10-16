class Blog
  include Mongoid::Document
	include Mongoid::Timestamps

	belongs_to :user
 
	field :title, type: String
  field :content, type: String
  field :views, type: Integer
end
