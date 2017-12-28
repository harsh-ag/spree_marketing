class Spree::ExportService::Contact

  HEADERS = [:email_address, :status_subscribed_unsubscribed, :optin_date, :optout_date, :number_of_orders, :avg_order_value, :date_of_last_order, :location_country, :sku, :product, :color, :size]

  def initialize(contacts, query_params, recipient)
    @contacts = contacts
    @recipient = recipient
    @query_params = query_params
    if query_params && query_params[:email_lists_name_eq]
      list = Spree::EmailList.find_by(name: query_params[:email_lists_name_eq])
      @variant = Spree::Variant.find_by(sku: list.variant_sku) if list.variant_sku.present?
    end
  end

  def send_data
    file_name = "/tmp/contacts-#{Date.today}.csv"
    File.open(file_name, 'wb') do |file|
      file.write(to_csv_data)
    end
    public_url = Spree::ExportService::Upload.new(file_name, "export/contacts-#{Date.today}.csv").push
    Spree::Export::ContactMailer.notify(public_url, @recipient).deliver
  end

  def to_csv_data
    CSV.generate do |csv|
      csv << HEADERS
      to_csv(csv)
    end
  end

  private
    def to_csv(csv)
      @contacts.each do |contact|
        csv << add_details(contact)
      end
    end

    def add_details(contact)
      HEADERS.collect do |key, value|
        send(key, contact)
      end
    end

    def email_address(contact)
      contact.email
    end

    def status_subscribed_unsubscribed(contact)
      contact.subscribed? ? 'Yes' : 'No'
    end

    def optin_date(contact)
      contact.optin_date
    end

    def optout_date(contact)
      contact.optout_date
    end

    def number_of_orders(contact)
      contact.placed_orders_count
    end

    def avg_order_value(contact)
      contact.avg_order_value
    end

    def date_of_last_order(contact)
      contact.last_placed_order_at
    end

    def location_country(contact)
      contact.location
    end

    def sku(contact)
      return unless @variant
      @variant.sku
    end

    def product(contact)
      return unless @variant
      @variant.name
    end

    def color(contact)
      return unless @variant
      @variant.color.try(:name)
    end

    def size(contact)
      return unless @variant
      size = @variant.option_values.joins(:option_type).where(spree_option_types: { name: 'Size' }).first.try(:name)
      size
    end

end
