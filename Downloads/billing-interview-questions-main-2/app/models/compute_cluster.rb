class ComputeCluster < ActiveRecord::Base
  has_many :virtual_machines
end
