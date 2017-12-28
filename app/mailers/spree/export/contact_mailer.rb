class Spree::Export::ContactMailer < Spree::BaseMailer

  def notify(file_location, to_address)
    @file_location = file_location
    mail to: to_address, subject: 'Contact Export successful', from: from_address
  end

end
