class OfficesController < ApplicationController
  before_action :set_office, only: [:show, :destroy]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    if params[:query].present?
      sql_query = "name ILIKE :query OR abilities ILIKE :query"
      @offices = Office.where(sql_query, query: "%#{params[:query]}%")
    else
      @offices = Office.all
    end
  end

  def show
    @bookings = Booking.where(office_id: @office.id)
    @bookings_dates = @bookings.map do |booking|
      {
        from: booking.start_date,
        to:   booking.end_date
      }
    end
  end

  def new
    @office = Office.new
    authorize @office
  end

  def edit
    @office = Office.find(params[:id])
    authorize @office
  end

  def create
    @office = Office.new(office_params)
    @office.user = current_user
    authorize @office

    if @office.save
      redirect_to @office, notice: 'Your work space was successfully created.'
    else
      render :new
    end
  end

  def update
    @office = Office.find(params[:id])
    authorize @office
    @office.update(office_params)
    redirect_to office_path(@office)
  end

  def destroy
    @office.destroy
    redirect_to root_path, notice: 'Your work space was successfully destroyed.'
  end

  private

  def set_office
    @office = Office.find(params[:id])
    authorize @office
  end

  def office_params
    params.require(:office).permit(:name, :description, :address, :price, :photo)
  end
end
