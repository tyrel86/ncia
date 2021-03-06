namespace :datamine do

	desc "Fetches data from xml and parses into mysql"
	task riseup: :environment do
		require('xml')

		def getMetaValueForKey( listing, search_key )
			postMetas = listing.find("wp:postmeta")
			
			postMeta = postMetas.select do |pm|
				pm_key = pm.find('wp:meta_key').first.entries.first.content
				search_key == pm_key
			end
			postMeta.first ? postMeta.first.find('wp:meta_value').first.entries.first.content : nil
		end

			raw_xml = open( Rails.root.to_s + "/db/wp_export_members.xml" ).read
			source = XML::Parser.string( raw_xml )
			content = source.parse
			listings = content.find("//item")
			listings.each do |listing|
				#Get virtual attributes
				name = listing.find('title').first.entries.first.content
				name = name.rstrip
				state = getMetaValueForKey( listing, 'dbt_selectstate' )
				cat = getMetaValueForKey( listing, 'dbt_selectc' )
				link = getMetaValueForKey( listing, 'dbt_text2' )
				type = getMetaValueForKey( listing, 'dbt_select' )
				type = "Regular" if type.nil?
				type = nil if type == "Subsidiary"
				type += " members" unless type.nil?
				old_member = Member.where( name: name ).first
				unless old_member.nil?
					old_member.type = type
					if old_member.update_attributes( state: state, category: cat, website: link )
						puts "updated #{listing.name}"
					else
						puts "Failed on #{name}"
						puts old_member.errors.messages
						puts "#{old_member.type} -- #{old_member.category} -- #{old_member.state}"
					end
				else
					puts "No record found for #{name}"
				end
			end
	end

end
