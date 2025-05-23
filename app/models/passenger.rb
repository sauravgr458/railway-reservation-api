# frozen_string_literal: true

# == Schema Information
#
# Table name: passengers
#
#  id         :bigint           not null, primary key
#  name       :string
#  age        :integer
#  gender     :string
#  has_child  :boolean
#  ticket_id  :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Passenger < ApplicationRecord
  belongs_to :ticket

  validates :name, presence: true, length: { maximum: 100 }
  validates :age, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :gender, presence: true, inclusion: { in: %w[male female other] }
  validates :has_child, inclusion: { in: [true, false] }

  validate :duplicate_passenger_on_ticket

  private

  def duplicate_passenger_on_ticket
    return if ticket.blank?

    existing = ticket.passengers.where(
      name: name.strip,
      age: age,
      gender: gender.downcase
    )

    existing = existing.where.not(id: id) if persisted?

    return unless existing.exists?

    errors.add(:base, 'Duplicate passenger on the same ticket is not allowed')
  end
end
