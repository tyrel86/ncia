class Staff

  include Mongoid::Document
	include Mongoid::Paperclip
	include Mongoid::Timestamps

  field :name, type: String
  field :title, type: String
  field :bio, type: String
  field :type, type: Integer

	attr_accessible :name, :title, :bio, :type, :image
	has_mongoid_attached_file :image, :styles => { :thumb => '125X' }

	 def type=(input)
    new_type = case input
      when ( 'staff' )
        0
      when ( 'board' )
        1
      else
        0
    end
    write_attribute(:type, new_type)
  end
  
  def type
    t = read_attribute(:type)
    case t
      when 0
        'staff'
      when 1
        'board'
			else
				'staff'
		end
	end

end
