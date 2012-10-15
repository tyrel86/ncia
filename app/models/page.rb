class Page
  include Mongoid::Document
	include Mongoid::Timestamps
  field :title, type: String
  field :content, type: String
  field :views, type: Integer
  field :side_bar_id, type: Integer
	attr_accessible :title, :content, :views, :side_bar_id
end
