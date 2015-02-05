# vim: ts=2

class CountryCodeType < Gs1CodeType
	validates :string, uniqueness: true
end
