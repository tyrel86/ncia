class EventsController < ApplicationController

	def index
		@events = Event.all
	end

	def admin_index
		@events = Event.all
		render layout: "backend"
	end

	# def show
	# 	@event = Event.find( params[:id] )
	# end

	def new
		@event = Event.new
		render layout: "backend"
	end

	def create
		@event = Event.new( params[:event] )
		year = params[:event]['time(1i)']
		month = params[:event]['time(2i)']
		day = params[:event]['time(3i)']
		hour = params[:event]['time(4i)']
		minuet = params[:event]['time(5i)']
	
		params[:event].remove!( 'time(1i)', 'time(2i)', 'time(3i)', 'time(4i)', 'time(5i)' )

		params[:event][:time] = Time.new( year, month, day, hour, minuet )
		if @event.save
			redirect_to events_admin_index_path
		else
			render "new"
		end
	end

	def edit
		@event = Event.find( params[:id] )
		render layout: "backend"
	end

	def update
		@event = Event.find( params[:id] )
		year = params[:event]['time(1i)']
		month = params[:event]['time(2i)']
		day = params[:event]['time(3i)']
		hour = params[:event]['time(4i)']
		minuet = params[:event]['time(5i)']
	
		params[:event].remove!( 'time(1i)', 'time(2i)', 'time(3i)', 'time(4i)', 'time(5i)' )

		params[:event][:time] = Time.new( year, month, day, hour, minuet )

		if @event.update_attributes( params[:event] )
			redirect_to events_admin_index_path
		else
			render "edit"
		end
	end

	def destroy
		Event.find( params[:id] ).destroy
		redirect_to events_admin_index_path
	end

end
