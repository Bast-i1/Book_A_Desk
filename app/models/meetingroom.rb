class Meetingroom < ApplicationRecord
  belongs_to :user
  has_many :bookings, dependent: :destroy
  has_many :reviews, through: :bookings
  has_one_attached :photo
  geocoded_by :address
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true
  validates :description, presence: true
  after_validation :geocode, if: :will_save_change_to_address?
end
