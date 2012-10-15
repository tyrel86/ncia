class ContactMessage
  include Mongoid::Document
  field :name, type: String
  field :email, type: String
  field :content, type: String
  field :read, type: Boolean
	attr_accessible :name, :email, :content
end
