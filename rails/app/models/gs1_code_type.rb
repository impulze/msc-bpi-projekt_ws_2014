# vim: ts=2

class Gs1CodeType < ActiveRecord::Base
	attr_accessible :string, :codelist_version
end
