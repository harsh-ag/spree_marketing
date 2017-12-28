Spree::Order.class_eval do

  self.state_machine.after_transition to: :complete, do: :update_email_list_details

  private

    def update_email_list_details
      contact = Spree::Contact.find_by(email: email)
      return true unless contact.present?
      avg_order_value = ((contact.avg_order_value.to_f + total) / (contact.placed_orders_count + 1))
      contact.update(placed_orders_count: contact.placed_orders_count.to_i + 1, avg_order_value: avg_order_value)
    end

end
