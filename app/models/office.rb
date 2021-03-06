class Office < ApplicationRecord
  belongs_to :user
  has_many :bookings, dependent: :destroy
  has_many :reviews, through: :bookings
  has_one_attached :photo
  geocoded_by :address
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true
  validates :description, presence: true
  after_validation :geocode, if: :will_save_change_to_address?

  def unavailable_dates
    bookings.pluck(:start_date, :end_date).map do |range|
      { from: range[0], to: range[1] }
    end
  end
end
