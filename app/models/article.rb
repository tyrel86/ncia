class Article
  include Mongoid::Document
	include Mongoid::Timestamps
  field :title, type: String
  field :content, type: String
	field :author, type: String
  field :views, type: Integer
  field :source, type: String
	attr_accessible :title, :content, :views, :source, :author
end
