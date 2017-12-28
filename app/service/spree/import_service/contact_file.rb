class Spree::ImportService::ContactFile

  HEADERS = [:email_address, :status_subscribed_unsubscribed, :optin_date, :optout_date, :number_of_orders, :avg_order_value, :date_of_last_order, :location]
  def initialize(uploaded_file_id)
    @uploaded_file = Spree::Asset.find(uploaded_file_id)
    @file = Spree::ImportService::SheetProcessorService.new(@uploaded_file, false, HEADERS)
    @error_rows = []
  end

  def call
    begin
      rows = @file.rows
      create_records(rows)
      create_error_file
      notify_admin_via_email
      # commenting below code seems like we don't need this
      # if sheet_valid?
      # else
      #   notify_admin_for_invalid_file_format
      # end
    ensure
      remove_temp_files
    end
  end

  def create_records(rows)
    rows.each do |row|
      ActiveRecord::Base.transaction do
        contact = Spree::Contact.create(contact_params(row))
        Spree::NewsLetterList.default.create_or_subscribe(contact.email) if contact.errors.empty?
        if row.to_h[:sku].present?
          contact = Spree::Contact.find_by(email: row.to_h[:email_address])
          return unless contact.present?
          add_contact_in_out_of_stock(contact, row.to_h[:sku])
        end
        add_errors_and_rollback(row, contact.errors) if contact.errors.any?
      end
    end
  end

  private

    def add_contact_in_out_of_stock(contact, sku)
      variant = Spree::Variant.find_by(sku: sku)
      unless variant.present?
        contact.errors.add(:base, 'Record was saved but Can not subscribe to variant')
        return
      end
      list = Spree::OutOfStockList.find_or_create(variant)
      list.create_or_subscribe(contact.email)
    end

    def add_errors_and_rollback(row, errors)
      @error_rows << row_with_errors(row, errors)
      raise ActiveRecord::Rollback
    end

    def notify_admin_for_invalid_file_format
      Spree::Import::SheetProcessorMailer.notify_file_format_error(@file.location).deliver_now
    end

    def notify_admin_via_email
      Spree::Import::SheetProcessorMailer.notify(@file.location,
          (@file.records_count - @error_file.records_count),
          @error_file.location,
          @error_file.records_count).deliver_now
    end

    def create_error_file
      @error_file = Spree::ImportService::SheetProcessorService.create_error_file(@error_rows, HEADERS)
    end

    def row_with_errors(row, errors)
      row.to_s.split(',')
      row << errors.full_messages.to_sentence
    end

    # We must remove temp files once we are done else they will block space on server.
    def remove_temp_files
      [@file, @error_file].each do |file|
        file.remove if file
      end
    end

    def contact_params(row)
      row_hash = row.to_h
      _params = {
        email: row_hash[:email_address],
        avg_order_value: row_hash[:avg_order_value],
        location: row_hash[:location_country],
        optin_date: process_date(row_hash[:optin_date]),
        optout_date: process_date(row_hash[:optout_date]),
        last_placed_order_at: process_date(row_hash[:date_of_last_order]),
        placed_orders_count: row_hash[:number_of_orders].to_i,
        data_source: Spree::Contact::VALID_DATA_SOURCES[:csv]
      }
    end

    def process_date(date)
      if date.present?
        DateTime.strptime(date, '%m/%d/%Y')
      end
    end

    def sheet_valid?
      (HEADERS - @file.uploaded_headers.map(&:to_sym)).empty?
    end
end
