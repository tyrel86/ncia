class Banner
  include Mongoid::Document
	include Mongoid::Paperclip
	include Mongoid::Timestamps
  field :active, type: Boolean
  field :name, type: String
	field :url, type: String
	has_mongoid_attached_file :image, :styles => { :side => '200X' }
	attr_accessible :name, :image, :url

	def activate
		self.active = true
		if self.save
			deactivate_all_except( self )
			return true
		else
			return false
		end
	end

	def deactivate_all_except( banner )
		Banner.not_in( id: banner.id ).update_all( active: false )
	end

	def self.the_current
		where( active: true ).first
	end
end
