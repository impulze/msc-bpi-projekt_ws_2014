# vim: ts=4 noet
product = Product.where(gtin: params[:gtin]).first

xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'
xml.comment! 'This is a work in progress example XML representation of one of our products.'
xml.pd(
  :productData,
  'xsi:schemaLocation' => 'urn:gs1:tsd:product_data:xsd:1 tsd/ProductData.xsd',
  'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
  'xmlns:pd' => 'urn:gs1:tsd:product_data:xsd:1') do
	xml.gtin ("%014d" % product[:gtin])
	xml.comment! 'see http://en.wikipedia.org/wiki/ISO_3166-1_numeric'
	xml.targetMarket product[:target_market]
	xml.informationProviderGLN product[:provider_gln]
	xml.informationProviderName product[:provider_name]
    xml.comment! 'see http://www.w3schools.com/schema/schema_dtypes_date.asp (Duration DataType)'
	xml.timeToLive product[:ttl]

	xml.productDataRecord do
		xml.comment! 'Free text field that can be used for your own purposes to differentiate between variants with the same GTIN.'
		xml.productionVariantDescription('Classic', 'languageCode' => 'EN')
		#xml.productionVariantDescription('Klassisch', 'languageCode' => 'DE')

		xml.productionVariantEffectiveDateTime product[:variant_dtime]

		# optional: productComponentRecord
		# optional: avpList

		# MODULES START HERE
		xml.module do
			xml.basicProductInformationModule do
				xml.comment! 'http://dict.leo.org/forum/viewUnsolvedquery.php?idThread=165130&idForum=1&lang=de&lp=ende'
				xml.productName('Duff Classic - The Alt Beer', 'languageCode' => 'EN')
				xml.consumerMarketingDescription('Not really old, just a little older than others.', 'languageCode' => 'EN')
				#xml.productName('Duff Klassisch - Das Alt', 'languageCode' => 'DE')
				#xml.consumerMarketingDescription('Nicht so alt, nur älter als andere.', 'languageCode' => 'DE')

				# TSD_sample.xml uses some optional elements
				#<gpcCategoryCode>10005372</gpcCategoryCode>
				#<regulatedProductName languageCode="us" codeListVersion="1.0">866074159</regulatedProductName>
				#<brandNameInformation>
				#	<brandName>brand 1</brandName>
				#	<languageSpecificBrandName languageCode="us" codeListVersion="1.0">341681552</languageSpecificBrandName>
				#</brandNameInformation>

				xml.productionInformationLink do
					xml.url 'http://path.to/duffs/classic#alt'
					# I don't know what to put in here, TSD_sample.xml uses 'VIDEO'?!
					xml.productInformationTypeCode 'LOL'
					xml.languageCode 'EN'
					# optional: avpList
				end

				xml.imageLink do
					xml.url 'http://upload.wikimedia.org/wikipedia/commons/0/07/AKE_Duff_Beer_IMG_5244_edit.jpg'
					# I don't know what to put in here, TSD_sample.xml uses 'LOGO'?!
					xml.productInformationTypeCode 'LOGO'
					xml.imagePixelHeight 3571
					xml.imagePixelWidth 5356
					# TSD_sample.xml uses GRM (for gram) here, so that's that...
					xml.fileSize(4, 'measurementUnitCode' => '4L')
					# optional: avpList
				end

				# TSD_sample.xml uses some more optional elements
				#<packagingSignatureLine>
				#<partyContactRoleCode codeListVersion="1.0">BRAND_OWNER</partyContactRoleCode>
				#<partyContactName>party 1</partyContactName>
				#<partyContactAddress>party 1 address</partyContactAddress>
				#<gln>1234567890128</gln>
				#<communicationChannel>
				#	<communicationChannelCode codeListVersion="1.0">EMAIL</communicationChannelCode>
				#	<communicationValue>com channel 1 value</communicationValue>
				#	<communicationChannelName>com channel 1</communicationChannelName>
				#</communicationChannel>

				# optional: avpList
			end

			# taken from: http://www.bierundwir.de/bier-selbst-brauen/rezepte-altbier-bier.htm
			xml.foodAndBeverageIngredientInformationModule do
				# I don't know what to put in here
				xml.ingredientStatement 'A lot of different malts go into the product. It also contains different kinds of amino-acids. Based on our specific product type the percentages and origins can differ.'
				# I don't know what to put in here
				xml.additivesStatement 'None.'
				# optionals in foodAndBeverageIngredient:
					# ingredientSequence
					# ingredientContentPercentage
					# ingredientCountryOfOriginCode
					# ingredientCatchZone
					# isIngredientHighlighted
					# subIngredient
					# avpList
				xml.foodAndBeverageIngredient do
					xml.ingredientName 'Pilsener Malz'
				end
				xml.foodAndBeverageIngredient do
					xml.ingredientName 'Münchener Malz'
				end
				xml.foodAndBeverageIngredient do
					xml.ingredientName 'Helles Weizenmalz'
				end
				xml.foodAndBeverageIngredient do
					xml.ingredientName 'Farbmalz'
				end
				xml.foodAndBeverageIngredient do
					xml.ingredientName 'Hallertauer Magnum'
				end
				xml.foodAndBeverageIngredient do
					xml.ingredientName 'Hallertauer Hersbrucker'
				end
				# optional: avpList
			end
		end
	end
end
