class Service < ApplicationRecord
  belongs_to :user
  belongs_to :company_owner, class_name: 'User'
  has_many :job_services
  has_many :jobs, through: :job_services
  
  validates :name, presence: true
  validates :price, presence: true
end