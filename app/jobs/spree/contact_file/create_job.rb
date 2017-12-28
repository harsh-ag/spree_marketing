class Spree::ContactFile::CreateJob < ApplicationJob
  def perform(contact_file_id)
    Spree::ImportService::ContactFile.new(contact_file_id).call
  end
end
