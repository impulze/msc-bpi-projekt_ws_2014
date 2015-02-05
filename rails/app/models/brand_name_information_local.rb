# vim: ts=2

class BrandNameInformationLocal < ActiveRecord::Base
	attr_accessible :string
	belongs_to :brand_name_information
end
