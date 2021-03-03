class MeetingroomsController < ApplicationController
  before_action :set_meetingroom, only: [:show, :destroy]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    if params[:query].present?
      sql_query = "name ILIKE :query OR abilities ILIKE :query"
      @meetingrooms = Meetingroom.where(sql_query, query: "%#{params[:query]}%")
    else
      @meetingrooms = Meetingroom.all
    end
  end

  def show
    @bookings = Booking.where(meetingroom_id: @meetingroom.id)
    @bookings_dates = @bookings.map do |booking|
      {
        from: booking.start_date,
        to:   booking.end_date
      }
    end
  end

  def new
    @meetingroom = Meetingroom.new
    authorize @meetingroom
  end

  def edit
    @meetingroom = Meetingroom.find(params[:id])
    authorize @meetingroom
  end

  def create
    @meetingroom = Meetingroom.new(meetingroom_params)
    @meetingroom.user = current_user
    authorize @meetingroom

    if @meetingroom.save
      redirect_to @meetingroom, notice: 'Your meeting room was successfully created.'
    else
      render :new
    end
  end

  def update
    @meetingroom = Meetingroom.find(params[:id])
    authorize @meetingroom
    @meetingroom.update(meetingroom_params)
    redirect_to meetingroom_path(@meetingroom)
  end

  def destroy
    @meetingroom.destroy
    redirect_to root_path, notice: 'Your meeting room was successfully destroyed.'
  end

  private

  def set_meetingroom
    @meetingroom = Meetingroom.find(params[:id])
    authorize @meetingroom
  end

  def meetingroom_params
    params.require(:meetingroom).permit(:name, :description, :address, :price, :photo)
  end
end
