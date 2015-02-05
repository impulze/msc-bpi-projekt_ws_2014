# vim: ts=2

class ProductDataRecord < ActiveRecord::Base
	attr_accessible  :variant_effective_datetime
	belongs_to :product
	has_one :production_variant_description
	has_many :basic_product_informations
	has_many :food_and_beverage_ingredient_informations
	has_many :product_quantity_informations
end
