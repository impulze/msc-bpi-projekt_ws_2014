# vim: ts=2

class ImageTypeCodeType < Gs1CodeType
	validates :string, uniqueness: true
end
