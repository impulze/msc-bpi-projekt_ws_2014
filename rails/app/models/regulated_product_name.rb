# vim: ts=2

class RegulatedProductName < ActiveRecord::Base
	attr_accessible :string, :codelist_version, :language
	belongs_to :basic_product_information
end
