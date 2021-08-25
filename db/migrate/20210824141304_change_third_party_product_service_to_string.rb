class ChangeThirdPartyProductServiceToString < ActiveRecord::Migration[6.1]
  def change
    change_column :dpa_exceptions, :third_party_product_service, :string
  end
end
