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

	def safe_image( size = :thumb )
		the_url = image.url( size )
		if File.basename( the_url ) == "missing.png"
			("<span class='member-image-alt'>#{acronym}</span>").html_safe
		else
			("<img src='#{the_url}' alt='logo-for-#{name}' />").html_safe
		end
	end

	def acronym
		words = name.split(' ')
		case words.size
			when 1
				("<span class='one-word'>#{words[0].size > 11 ? words[0][0..10] : words[0] }</span>").html_safe
			else
				words = words.inject([]) { |result, word| result.push word[0].upcase }
				words = (words.size > 4) ? words[0..3] : words
				("<span class='acronym'>#{words.join}</span>").html_safe
		end
	end

	#Class methods
	class << self
		def get_featured_array
			Member.all.inject([]) do |r,e|
				r.push e unless File.basename( e.image.url(:thumb) ) == "missing.png"
				break if r.size >= 15
				r
			end
		end	
	end

end
