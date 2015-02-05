# vim: ts=2

class ProductQuantityInformation < ActiveRecord::Base
	attr_accessible :percentage_of_alcohol_by_volume
	belongs_to :measurement_type
	belongs_to :product_data_record
end
