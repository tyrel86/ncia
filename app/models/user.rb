class User 
  include Mongoid::Document
  include Mongoid::Timestamps
  
  attr_accessible :username, :email, :password, :password_confirmation, :first_name, :last_name
	
	before_create :generate_token
  before_save :prepare_password

  attr_accessor :password, :password_confirmation

	has_one :member
	has_many :blogs
  
  field :username,               :type => String
  field :email,                  :type => String
  field :first_name,             :type => String
  field :last_name,               :type => String
  field :password_hash,          :type => String
  field :password_salt,          :type => String
  field :auth_token,             :type => String
  field :password_reset_token,   :type => String
  field :password_reset_sent_at, :type => Time
	field :admin,                  :type => Boolean
	field :active,                 :type => Boolean

  
  
	validates_presence_of :email
	validates_uniqueness_of :email, :email, :allow_blank => false
  validates_format_of :username, :with => /^[-\w\._@]+$/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  
  # login can be either username or email address
	def build_member
		m = Member.create
		self.member = m
	end 	

	def self.authenticate(login, pass)
    user = find_by( :username => login )  || find_by( :email => login )
    return user if user && user.matching_password?(pass)
  end
  
  def matching_password?(pass)
    self.password_hash == encrypt_password(pass)
  end
  
  def prepare_password
    unless password.blank?
      self.password_salt = Digest::SHA1.hexdigest([Time.now, rand].join)
      self.password_hash = encrypt_password(password)
    end
  end
  
  def encrypt_password(pass)
    Digest::SHA1.hexdigest([pass, password_salt].join)
  end

	def send_password_reset
		generate_token_reset
		self.password_reset_sent_at = Time.zone.now
		save!
		UserMailer.password_reset(self).deliver
	end

	def generate_token
		begin
			self.auth_token = SecureRandom.urlsafe_base64
		end while ( ! User.find_by( :auth_token => self.auth_token ).nil? )
	end

	def generate_token_reset
		begin
			self.password_reset_token = SecureRandom.urlsafe_base64
		end while ( ! User.find_by( :password_reset_token => self.password_reset_token ).nil? )
	end

	def active?
		return true if member && active
	end
	
	def decern_next_step
		unless member
			return "/members/new"
		end
		unless active
			return "/users/payment"
		end
	end
	
	def self.in_next_step( controller , path )
		case path
			when "/members/new"
				if controller == "members"
					return true
				end
			when "/users/payment"
				if controller == "users"
					return true
				end
		end
		false
	end

end
