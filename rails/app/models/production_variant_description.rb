# vim: ts=2

class ProductionVariantDescription < ActiveRecord::Base
	attr_accessible :string, :codelist_version, :language
	belongs_to :product_data_record
end
