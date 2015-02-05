# vim: ts=2

class ProductInformationTypeCodeType < Gs1CodeType
	validates :string, uniqueness: true
end
