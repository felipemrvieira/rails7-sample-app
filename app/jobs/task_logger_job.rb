class TaskLoggerJob < ApplicationJob
  queue_as :default

  def perform
    puts "TaskLoggerJob is performed ->->->->->->->->"
    EmissionUpload.destroy_all
  end
end
