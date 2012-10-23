class Member
  include Mongoid::Document
	include Mongoid::Paperclip
	include Mongoid::Timestamps

	belongs_to :user
	before_save   :scrub

  field :name, type: String
  field :description, type: String
	field :discount, type: String
	field :type, type: String
	field :cycle, type: String
	field :category, type: String
	field :state, type: String
	field :phone, type: String
	field :aproval_hash, type: String
	field :website, type: String

	has_mongoid_attached_file :image, :styles => { :thumb => '135x75>', :large => '200X' }
	attr_accessible :name, :description, :image, :discount, :state, :category, :website
	attr_accessor :query

	validates_inclusion_of :state, allow_nil: true, in: LEGAL_STATE_ARRAY
	validates_inclusion_of :cycle, allow_nil: true, in: CYCLES 
	validates_inclusion_of :category, allow_nil: true, in: CATEGORY

	def scrub
		self.phone.gsub(/[^0-9]/, "") if phone
	end


	def safe_image( size = :thumb )
		the_url = image.url( size )
		if File.basename( the_url ) == "missing.png"
			("<span class='member-image-alt'>#{acronym}</span>").html_safe
		else
			("<img src='#{the_url}' alt='logo-for-#{name}' />").html_safe
		end
	end

	def safe_image_large
		the_url = image.url
		if File.basename( the_url ) == "missing.png"
			("<span class='member-image-alt'>#{acronym}</span>").html_safe
		else
			("<img src='#{the_url}' alt='logo-for-#{name}' />").html_safe
		end
	end

	def acronym
		name
	end

	def has_all_attributes?
	  name && description && tags && discount && type && state
	end

	def price
		PRICE_MAPPING[type][cycle]
	end

	def set_and_get_aproval_hash
		return aproval_hash if aproval_hash
		self.aproval_hash = SecureRandom.urlsafe_base64
		save
		reload
		aproval_hash
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
