class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :company_owner, class_name: 'User', optional: true
  has_many :workers, class_name: 'User', foreign_key: 'company_owner_id'
  has_many :worker_requests, class_name: 'WorkerRequest', foreign_key: 'company_owner_id'
  has_many :jobs
  has_many :services

  ROLES = %w[company_owner worker].freeze

  validates :role, inclusion: { in: ROLES }, on: :create
  validates :company_owner, presence: true, unless: :company_owner?, on: :create
  validates :company_code, presence: true, length: { is: 6 }, uniqueness: true, if: :company_owner?

  before_validation :generate_company_code, if: :company_owner?
  attr_accessor :joining_company_code

  def company_owner?
    role == 'company_owner'
  end

  def worker?
    role == 'worker'
  end

  def accessible_jobs
    if company_owner?
      Job.where(company_owner_id: id)
    else
      Job.where(company_owner_id: company_owner_id)
    end
  end

  def accessible_services
    if company_owner?
      services
    else
      company_owner.present? ? company_owner.services : Service.none
    end
  end

  private

  def generate_company_code
    return if company_code.present?
    loop do
      self.company_code = SecureRandom.alphanumeric(6).upcase
      break unless User.exists?(company_code: company_code)
    end
  end
end