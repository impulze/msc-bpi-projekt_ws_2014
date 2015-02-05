# vim: ts=2

class BrandNameInformation < ActiveRecord::Base
	has_one :brand_name_information_local
	has_many :brand_name_information_international
	belongs_to :basic_product_information
end
