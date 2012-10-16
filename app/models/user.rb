class User 
  include Mongoid::Document
  include Mongoid::Timestamps
  
  attr_accessible :username, :email, :password, :password_confirmation
	
	before_create :generate_token

  attr_accessor :password, :password_confirmation

	has_one :member
	has_many :blogs
  
  field :username,               :type => String
  field :email,                  :type => String
  field :password_hash,          :type => String
  field :password_salt,          :type => String
  field :auth_token,             :type => String
  field :password_reset_token,   :type => String
  field :password_reset_sent_at, :type => Time
	field :admin,                  :type => Boolean
	field :active,                  :type => Boolean

  
  before_save :prepare_password
  
  validates_presence_of :username
	validates_presence_of :email
  validates_uniqueness_of :username, :email, :allow_blank => false
	validates_uniqueness_of :email, :email, :allow_blank => false
  validates_format_of :username, :with => /^[-\w\._@]+$/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  
  # login can be either username or email address
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
	
end
