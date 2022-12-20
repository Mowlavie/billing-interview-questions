class Event < ActiveRecord::Base
  belongs_to :virtual_machine

  after_create :log_event

  def log_event
    Rails.logger.info("#{self.created_at} Event create: #{self.virtual_machine.name} (#{self.virtual_machine.id}) type: #{self.event_type}")
  end
end
