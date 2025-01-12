class JobService < ApplicationRecord
  belongs_to :job
  belongs_to :service
  belongs_to :added_by, class_name: 'User'
end