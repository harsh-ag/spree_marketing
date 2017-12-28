FactoryGirl.define do
  factory :newsletter_list, class: Spree::NewsLetterList do
    name FFaker::Internet.name
  end

  factory :out_of_stock_list, class: Spree::OutOfStockList do
    name FFaker::Internet.name
    variant_sku { create(:variant).sku }
  end
end
