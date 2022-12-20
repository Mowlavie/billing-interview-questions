class VirtualMachine < ActiveRecord::Base
  has_many :events
  belongs_to :compute_cluster
end
