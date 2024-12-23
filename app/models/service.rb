class Service < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true
  has_many :job_services
  has_many :jobs, through: :job_services
end
