class Ticket < ApplicationRecord
  has_many :passengers, dependent: :destroy
end
