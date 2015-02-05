# vim: ts=4 noet
product = Product.where(gtin: params[:gtin]).first

xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'
xml.pd(:productData,
       'xsi:schemaLocation' => 'urn:gs1:tsd:product_data:xsd:1 tsd/ProductData.xsd',
       'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
       'xmlns:pd' => 'urn:gs1:tsd:product_data:xsd:1') do
	xml.gtin ("%014d" % product[:gtin])
	xml.comment! 'see http://en.wikipedia.org/wiki/ISO_3166-1_numeric'
	xml.targetMarket product.target_market[:string]
	xml.informationProviderGLN ("%013d" % product[:provider_gln])
	xml.informationProviderName product[:provider_name]
	xml.comment! 'see http://www.w3schools.com/schema/schema_dtypes_date.asp (Duration DataType)'
	xml.timeToLive product[:ttl]

	product.product_data_records.each do |pdr|
		xml.productDataRecord do
			vdesc = pdr.production_variant_description
			xml.productionVariantDescription(vdesc[:string], 'languageCode' => vdesc[:language])

			xml.productionVariantEffectiveDateTime pdr[:variant_effective_datetime]

			# MODULES START HERE
			pdr.basic_product_informations.each do |bi|
				xml.module do
					xml.bpim(:basicProductInformationModule,
					         'xsi:schemaLocation' => 'urn:gs1:tsd:basic_product_information_module:xsd:1 tsd/BasicProductInformationModule.xsd',
					         'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
					         'xmlns:bpim' => 'urn:gs1:tsd:basic_product_information_module:xsd:1') do
						bi.product_names.each do |pn|
							xml.productName(pn[:string], 'languageCode' => pn[:language])
						end

						bi.consumer_marketing_descriptions.each do |cmd|
							xml.consumerMarketingDescription(cmd[:string], 'languageCode' => cmd[:language])
						end

						xml.comment! 'see http://www.gs1.org/1/productssolutions/gdsn/gpc/browser/index.html'
						xml.gpcCategoryCode bi[:gpc_category_code]

						xml.comment! 'regulated description according to Los-Kennzeichnungs-Verordnung (Artikel 3)'
						bi.regulated_product_names.each do |rpn|
							xml.regulatedProductName(rpn[:string], 'languageCode' => rpn[:language])
						end

						xml.brandNameInformation do
							xml.brandName bi.brand_name_information.brand_name_information_local[:string]
						end

						bi.product_information_links.each do |pil|
							xml.productInformationLink do
								xml.url pil[:url]
								xml.comment! 'http://apps.gs1.org/GDD/Pages/clDetails.aspx?semanticURN=urn:gs1:gdd:cl:TSD_ProductInformationTypeCode&release=1'
								xml.productInformationTypeCode pil.product_information_type_code_type[:string]
								xml.comment! 'language used on the website'
								xml.languageCode pil.language_type_code_type[:string]
							end
						end

						bi.image_links.each do |il|
							xml.imageLink do
								xml.url il[:url]
								xml.comment! 'see http://apps.gs1.org/GDD/Pages/clDetails.aspx?semanticURN=urn:gs1:gdd:cl:TSD_ImageTypeCode&release=1'
								xml.imageTypeCode il.image_type_code_type[:string]
								xml.imagePixelHeight il[:height]
								xml.imagePixelWidth il[:width]
								xml.comment! 'see http://www.gs1.org/docs/gsmp/eancom/2012/ean02s4/part3/dc313.htm'
								xml.fileSize(il.measurement_type[:value], 'measurementUnitCode' => il.measurement_type[:unit_code])
							end
						end

						bi.packaging_signature_lines.each do |psl|
							xml.packagingSignatureLine do
								xml.comment! 'see http://apps.gs1.org/GDD/Pages/clDetails.aspx?semanticURN=urn:gs1:gdd:cl:TSD_PartyContactRoleCode&release=1'
								xml.partyContactRoleCode(psl.party_contact_role_code_type[:string])
								xml.partyContactName(psl[:contact_name])
								xml.partyContactAddress(psl[:contact_address])
								xml.gln(psl[:gln])
								psl.communication_channel_types.each do |cc|
									xml.communicationChannel do
										xml.communicationChannelCode(cc.communication_channel_code_type[:string])
										xml.communicationValue(cc[:value])
										xml.communicationChannelName(cc[:name]) unless cc[:name].nil?
									end
								end
							end
						end
					end
				end

				pdr.food_and_beverage_ingredient_informations.each do |f|
					xml.module do
						xml.fabiim(:foodAndBeverageIngredientInformationModule,
							         'xsi:schemaLocation' => 'urn:gs1:tsd:food_and_beverage_information_module:xsd:1 tsd/FoodAndBeverageIngredientInformationModule.xsd',
							         'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
							         'xmlns:fabiim' => 'urn:gs1:tsd:food_and_beverage_information_module:xsd:1') do
							f.food_and_beverage_ingredient_statements.each do |fs|
								xml.ingredientStatement(fs[:string], 'languageCode' => fs[:language])
							end
							f.food_and_beverage_ingredients.each do |fi|
								xml.foodAndBeverageIngredient do
									fi.food_and_beverage_ingredient_names.each do |fin|
										xml.ingredientName(fin[:string], 'languageCode' => fin[:language])
									end
									xml.ingredientSequence(fi[:sequence])
									xml.ingredientCountryOfOriginCode(fi.country_code_type[:string])
								end
							end
						end
					end
				end

				pdr.product_quantity_informations.each do |pq|
					xml.module do
						xml.pqim(:productQuantityInformationModule,
							         'xsi:schemaLocation' => 'urn:gs1:tsd:product_quantity_information_module:xsd:1 tsd/ProductQuantityInformationModule.xsd',
							         'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
							         'xmlns:pqim' => 'urn:gs1:tsd:product_quantity_information_module:xsd:1') do
							xml.netContent(pq.measurement_type[:value], 'measurementUnitCode' => pq.measurement_type[:unit_code])
							xml.percentageOfAlcoholByVolume pq[:percentage_of_alcohol_by_volume]
						end
					end
				end
			end
		end
	end
end
