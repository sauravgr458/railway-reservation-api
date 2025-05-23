# frozen_string_literal: true

# == Schema Information
#
# Table name: tickets
#
#  id         :bigint           not null, primary key
#  status     :string, default: "waiting_list"
#  berth_type :string
#  berth_number :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Ticket < ApplicationRecord
  has_many :passengers, dependent: :destroy

  scope :confirmed,     -> { where(status: 'confirmed') }
  scope :rac,           -> { where(status: 'rac') }
  scope :waiting_list,  -> { where(status: 'waiting_list') }

  STATUSES = %w[confirmed rac waiting_list].freeze
  BERTH_TYPES = %w[lower middle upper side-lower].freeze

  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :berth_type, inclusion: { in: BERTH_TYPES }, allow_nil: true
end
