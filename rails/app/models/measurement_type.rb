# vim: ts=2

class MeasurementType < ActiveRecord::Base
	attr_accessible :unit_code, :value, :codelist_version
end
