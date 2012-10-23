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
				state = getMetaValueForKey( listing, 'dbt_selectstate' )
				type = getMetaValueForKey( listing, 'dbt_selectc' )
				link = getMetaValueForKey( listing, 'dbt_text2' )
				type2 = getMetaValueForKey( listing, 'dbt_select' )
				old_member = Member.where( name: name ).first
				old_member.update_attributes( state: state, category: type, website: link, type: type2 ) unless old_member.nil?
				puts "Failed for #{name}: " if old_member.nil?

			end
	end

end
