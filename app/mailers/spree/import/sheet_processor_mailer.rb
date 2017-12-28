class Spree::Import::SheetProcessorMailer < Spree::BaseMailer

  def notify_file_format_error(file_location)
    attach_file(file_location)
    mail to: Spree::Config[:email_admin_list], subject: 'Customer Upload Not Succesful', from: from_address
  end

  def notify(location, process_contacts, error_file_location, error_records)
    attach_file(location)
    attach_file(error_file_location)
    @process_contacts_count = process_contacts
    @error_records_count = error_records
    mail to: Spree::Config[:email_admin_list], subject: 'Customer Upload Completed', from: from_address
  end

  private

    def attach_file(file_location)
      @file_name = File.basename(file_location)
      attachments[@file_name] = {
        mime_type: 'text/csv',
        content: File.read(file_location)
      }
    end
end
