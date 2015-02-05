# vim: ts=2

class HomeController < ApplicationController
	def index
		tm = TargetMarket.where(:string => 278).first_or_create
		pdr = ProductDataRecord.new(:variant_effective_datetime => '2014-01-01T00:00:00Z')
		vdesc = ProductionVariantDescription.new(:string => 'Duff Klassisch', :language => 'DE')
		pdr.production_variant_description = vdesc
		bi = BasicProductInformation.new(:gpc_category_code => '10000159')
		pn1 = ProductName.new(:string => 'Altbier', :language => 'DE')
		pn1.basic_product_information = bi
		pn2 = ProductName.new(:string => 'Alt Beer', :language => 'EN')
		pn2.basic_product_information = bi
		rpn1 = RegulatedProductName.new(:string => 'Dunkles obergäriges Bier', :language => 'DE')
		rpn1.basic_product_information = bi
		rpn2 = RegulatedProductName.new(:string => 'Dark top-fermented beer', :language => 'EN')
		rpn2.basic_product_information = bi
		cmd1 = ConsumerMarketingDescription.new(:string => 'Nicht so alt, nur älter als andere.', :language => 'DE')
		cmd1.basic_product_information = bi
		bni = BrandNameInformation.new
		bnil = BrandNameInformationLocal.new(:string => 'Duff')
		bni.brand_name_information_local = bnil
		bi.brand_name_information = bni
		ltc = LanguageTypeCodeType.where(:string => 'DE').first_or_create
		pil = ProductInformationLink.new(:url => 'http://example.com/duff')
		pil.language_type_code_type = ltc
		pitc = ProductInformationTypeCodeType.where(:string => 'WEBSITE').first_or_create
		pil.product_information_type_code_type = pitc
		il = ImageLink.new(:url => 'http://upload.wikimedia.org/wikipedia/commons/0/07/AKE_Duff_Beer_IMG_5244_edit.jpg', :height => 3571, :width => 5356)
		il.language_type_code_type = ltc
		itc = ImageTypeCodeType.where(:string => 'LOGO').first_or_create
		il.image_type_code_type = itc
		fs = MeasurementType.where(:unit_code => '4L', :value => 4).first_or_create
		il.measurement_type = fs
		psl = PackagingSignatureLine.new(:contact_name => 'Duff Brewery', :contact_address => 'Elbchaussee 111, 20095 Hamburg', :gln => 2865195120000)
		pcr = PartyContactRoleCodeType.where(:string => 'BRAND_OWNER').first_or_create
		psl.party_contact_role_code_type = pcr
		ccw = CommunicationChannelType.new(:value => 'http://example.com')
		ccwc = CommunicationChannelCodeType.where(:string => 'WEBSITE').first_or_create
		ccw.communication_channel_code_type = ccwc
		cct = CommunicationChannelType.new(:value => '+494011112222333', :name => 'Hotline')
		cctc = CommunicationChannelCodeType.where(:string => 'TELEPHONE').first_or_create
		cct.communication_channel_code_type = cctc
		cce = CommunicationChannelType.new(:value => 'duff@example.com')
		ccec = CommunicationChannelCodeType.where(:string => 'EMAIL').first_or_create
		cce.communication_channel_code_type = ccec
		psl.communication_channel_types.push(ccw)
		psl.communication_channel_types.push(cct)
		psl.communication_channel_types.push(cce)
		bi.packaging_signature_lines.push(psl)
		fbii = FoodAndBeverageIngredientInformation.new
		fbis = FoodAndBeverageIngredientStatement.new(:string => 'Verschiedene Malze mit Hopfen gekocht und mit verschiedenen Hefekulturen zugesetzt.', :language => 'DE')
		fbii.food_and_beverage_ingredient_statements.push(fbis)
		fbin1 = FoodAndBeverageIngredientName.new(:string => 'Münchener Malz', :language => 'DE')
		fbi1 = FoodAndBeverageIngredient.new(:sequence => 1)
		fbi1.food_and_beverage_ingredient_names.push(fbin1)
		fbi1.country_code_type = CountryCodeType.where(:string => 'DE').first_or_create
		fbin2 = FoodAndBeverageIngredientName.new(:string => 'Pilsener Malz', :language => 'DE')
		fbi2 = FoodAndBeverageIngredient.new(:sequence => 2)
		fbi2.food_and_beverage_ingredient_names.push(fbin2)
		fbi2.country_code_type = CountryCodeType.where(:string => 'DE').first_or_create
		fbin3 = FoodAndBeverageIngredientName.new(:string => 'Helles Weizenmalz', :language => 'DE')
		fbi3 = FoodAndBeverageIngredient.new(:sequence => 3)
		fbi3.food_and_beverage_ingredient_names.push(fbin3)
		fbi3.country_code_type = CountryCodeType.where(:string => 'DE').first_or_create
		fbin4 = FoodAndBeverageIngredientName.new(:string => 'Wyeast Hefe', :language => 'DE')
		fbi4 = FoodAndBeverageIngredient.new(:sequence => 4)
		fbi4.food_and_beverage_ingredient_names.push(fbin4)
		fbi4.country_code_type = CountryCodeType.where(:string => 'DE').first_or_create
		fbin5 = FoodAndBeverageIngredientName.new(:string => 'Hallertaler Magnum', :language => 'DE')
		fbi5 = FoodAndBeverageIngredient.new(:sequence => 5)
		fbi5.food_and_beverage_ingredient_names.push(fbin5)
		fbi5.country_code_type = CountryCodeType.where(:string => 'DE').first_or_create
		fbin6 = FoodAndBeverageIngredientName.new(:string => 'Hallertaler Hersbrucker', :language => 'DE')
		fbi6 = FoodAndBeverageIngredient.new(:sequence => 6)
		fbi6.food_and_beverage_ingredient_names.push(fbin6)
		fbi6.country_code_type = CountryCodeType.where(:string => 'DE').first_or_create
		fbin7 = FoodAndBeverageIngredientName.new(:string => 'Farbmalz', :language => 'DE')
		fbi7 = FoodAndBeverageIngredient.new(:sequence => 7)
		fbi7.country_code_type = CountryCodeType.where(:string => 'DE').first_or_create
		fbi7.food_and_beverage_ingredient_names.push(fbin7)
		fbii.food_and_beverage_ingredients.push(fbi1)
		fbii.food_and_beverage_ingredients.push(fbi2)
		fbii.food_and_beverage_ingredients.push(fbi3)
		fbii.food_and_beverage_ingredients.push(fbi4)
		fbii.food_and_beverage_ingredients.push(fbi5)
		fbii.food_and_beverage_ingredients.push(fbi6)
		fbii.food_and_beverage_ingredients.push(fbi7)
		pqi = ProductQuantityInformation.new(:percentage_of_alcohol_by_volume => 4.7)
		nc = MeasurementType.where(:unit_code => 'millilitre', :value => 500).first_or_create
		pqi.measurement_type = nc
		p = Product.new(:gtin => 2865195100017, :provider_gln => 286519520000, :provider_name => 'Duff Brewery', :ttl => 'P1D')
		p.target_market = tm
		bi.product_names.push(pn1)
		bi.product_names.push(pn2)
		bi.consumer_marketing_descriptions.push(cmd1)
		bi.product_information_links.push(pil)
		bi.image_links.push(il)
		pdr.basic_product_informations.push(bi)
		pdr.food_and_beverage_ingredient_informations.push(fbii)
		pdr.product_quantity_informations.push(pqi)
		p.product_data_records.push(pdr)
		p.save!
		respond_to do |format|
			format.html
		end
	end

	def items
		@code = 'success'
		respond_to do |format|
		format.xml
			#render :layout => false
		end
	end

	def maintenance
		respond_to do |format|
			format.html
		end
	end
end
