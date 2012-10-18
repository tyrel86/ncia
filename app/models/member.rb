class Member
  include Mongoid::Document
	include Mongoid::Paperclip
	include Mongoid::Timestamps

	belongs_to :user
	before_save   :scrub

  field :name, type: String
  field :description, type: String
  field :tags, type: String
	field :discount, type: String
	field :type, type: String
	field :cycle, type: String
	field :address, type: String
	field :city, type: String
	field :state, type: String
	field :zip, type: String
	field :phone, type: String
	field :aproval_hash, type: String

	has_mongoid_attached_file :image, :styles => { :thumb => '135x75>', :large => '200X' }
	attr_accessible :name, :description, :tags, :image, :discount, :address, :city, :state, :zip, :phone
	attr_accessor :query

	validates_inclusion_of :state, in: LEGAL_STATE_ARRAY
	validates_inclusion_of :cycle, in: CYCLES 
	validates_presence_of :name
	validates_presence_of :tags
	validates_presence_of :address
	validates_presence_of :city
	validates_presence_of :state
	validates_presence_of :zip
	validates_presence_of :phone
	validates_presence_of :type
	validates_presence_of :cycle

	def scrub
		self.phone.gsub(/[^0-9]/, "")
	end


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

	def has_all_attributes?
	  name && description && tags && discount && type && state
	end

	def price
		PRICE_MAPPING[type][cycle]
	end

	def set_and_get_aproval_hash
		self.aproval_hash = SecureRandom.urlsafe_base64
		save
	end

	#Class methods
	def self.get_featured_array
		all.inject([]) do |r,e|
			r.push e unless File.basename( e.image.url(:thumb) ) == "missing.png"
			return r if r.size >= 15
			r
		end
	end

	def self.search( query, state )
		members = all
		query1 = members.where( name: Regexp.new( query, "i" ) )
		query1 = query1.where( state: state ) if state
		query2 = members.where( tags: Regexp.new( query, "i" ) )
		query2 = query2.where( state: state ) if state
		query3 = members.where( discount: Regexp.new( query, "i" ) )
		query3 = query3.where( state: state ) if state
		(query1 + query2 + query3).uniq
	end

end
