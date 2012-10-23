class MembersController < ApplicationController

	before_filter :require_member, only: [:portal_show, :edit, :update]
	before_filter :get_state_and_cat_arrays
	before_filter :require_admin, only: [:destroy, :admin_index]
	
	def get_state_and_cat_arrays
		@states = Member.all.to_a.inject([]) do |r,v|
			r.push v.state unless r.include? v.state
			r
		end
		@categories = Member.all.to_a.inject([]) do |r,v|
			r.push v.category unless r.include? v.category
			r
		end
		@states.delete( nil ) unless @states.empty?
		@categories.delete( nil ) unless @categories.empty?
		@states.sort!
		@categories.sort!
	end

	def index
		@regular_members = Member.where( type: "Regular" )
		@sustaining_members = Member.where( type: "Sustaining" )
		@sponsoring_members = Member.where( type: "Sponsoring" )
		render layout: "join"
	end

	def discounts_search
		state = params[:member][:state]
		state.empty? ? (state = nil) : true
		@members = Member.search( params[:member][:query], state )
		@members = @members.inject([]) do |r,m|
			(m.discount.nil? or m.discount.empty?) ? r : r.push(m)
		end
		render layout: "join"
	end

	def discounts
		members = Member.all.to_a
		@members = []
		5.times do
			begin
				member = members.sample
				members.delete member
			end while member.discount.nil? or member.discount.empty?
			@members.push member
		end
	end

	def search_index
		search_terms = {}
		search_terms[:state] = params['member']['state'] unless params['member']['state'].empty?
		search_terms[:category] = params['member']['category'] unless params['member']['category'].empty?
		members = Member.where( search_terms )
		@regular_members = members.where( type: "Regular" )
		@sustaining_members = members.where( type: "Sustaining" )
		@sponsoring_members = members.where( type: "Sponsoring" )
		render "index", layout: "join"
	end

	def admin_index
		@members = Member.all
		render layout: "backend"
	end

	def show
		@member = Member.find( params[:id] )
	end

	def portal_show
		@member = current_user.member
		if @member.name.nil?
			render "edit", layout: "portal", notice: "Your member profile which gives you exposure through member discounts and our directory is not filled out. Its very easy just fill out the form bellow. Thank you."
		else
			render layout: "portal"
		end
	end

	def new
		@member = Member.new
		render layout: "portal"
	end

	def create
		type = params[:member][:type]
		cycle = params[:member][:cycle]
		params[:member].remove! :cycle, :type
		@member = Member.new( params[:member] )
		@member.type = type
		@member.cycle = cycle
		if @member.save
			current_user.member = @member
			@member.reload
			redirect_to members_portal_show_path( @member.id )
		else
			render "new", layout: "portal"
		end
	end

	def edit
		@member = Member.find( params[:id] )
		render layout: "portal"
	end

	def update
		@member = Member.find( params[:id] )
		if @member.update_attributes( params[:member] )
			redirect_to members_portal_show_path( @member.id )
		else
			render "edit", layout: "portal"
		end
	end

	def destroy
		Member.find( params[:id] ).destroy
		redirect_to members_admin_index_path
	end

end
