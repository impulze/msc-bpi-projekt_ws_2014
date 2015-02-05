# vim: ts=2

class BrandNameInformationInternational < ActiveRecord::Base
	attr_accessible :string, :codelist_version, :language
	belongs_to :brand_name_information
end
