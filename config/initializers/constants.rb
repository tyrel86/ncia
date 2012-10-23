LEGAL_STATE_ARRAY = [ 'Any', 'Alaska', 'Arizona', 'California', 'Colorado', 
                                          'Connecticut', 'DC', 'Delaware', 'Hawaii', 'Maine', 'Michigan', 
                                          'Montana', 'Nevada', 'New Jersey', 'New Mexico', 
                                          'Oregon', 'Rhode Island','Washington','District Of Columbia' ]

CYCLES = ['Monthly','Annual']

ACCOUNT_TYPES = ['Sustaining members', 'Sponsoring members', 'Regular members']
ACCOUNT_TYPES_DISPLAY = ['Sustaining', 'Sponsoring', 'Regular']

PRICE_MAPPING = {'Sustaining members' => { 'Monthly'  => 500,
																	 'Annual' => 5000 },
								 'Sponsoring members' => { 'Monthly'  => 250,
																	 'Annual' => 2500 },
						'Regular Members members' => { 'Monthly'  => 100,
																	 'Annual' => 1000 }}

module PriceHelper
	def self.get_type_for_price(price)
		case price
			when 500, 5000
				"Sustaining members"
			when 250, 2500
				"Sponsoring members"
			when 100, 1000
				"Regular members"
		end
	end
end


STATE_MAPPINGS = { 'Alaska' => 'AK', 'Arizona' => 'AZ', 'California' => 'CA', 'Colorado' => 'CO',
									 'Connecticut' => 'CT', 'DC' => 'DC', 'Delaware' => 'DE', 'Hawaii' => 'HI',
									 'Maine' => 'ME', 'Nevada' => 'NV', 'New Jersey' => 'NJ', 'New Mexico' => 'NM',
									 'Oregon' => 'OR', 'Rode Island' => 'RI' }

CATEGORY = ['Any','Medical cannabis providers','Cannabis cultivation supply','Analytical labs','Law offices',
						'Professional services','Software','Hemp products','Cannabis accessories','Medical cannabis infused products','Other']
