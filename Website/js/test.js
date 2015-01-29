
var add = function(){
		console.log("Test");
		var gtin = document.getElementById('gtin').value;
		var variante = document.getElementById('variante').value;
		var name = document.getElementById('name').value;
		var nameEN = document.getElementById('nameEN').value;
		var werbespruch = document.getElementById('werbespruch').value;
		var sorte = document.getElementById('sorte').value;
		var sorteEN = document.getElementById('sorteEN').value;
		var alkg = document.getElementById('alkoholgehalt').value;
		var inhaltsstoffe = document.getElementById('inhaltsstoffe').value;
		var inhaltsangabe = document.getElementById('inhaltsangabe').value;
		var bildurl = document.getElementById('bildurl').value;
		var infourl = document.getElementById('infourl').value;

		document.getElementById('area').value =":gtin => "
		+gtin+", :informationProviderGLN => 2865195100007, :informationProviderName => 'Duff Brewery', :timeToLive => 'P1D', :productionVariantDescription => '"
		+variante+"', :productVariantEffectiveDateTime => '2014-01-01T00:00:00Z', :productNameDE => '"
		+name+"', :productNameEN => '"
		+nameEN+"', :consumerMarketingDescription => '"
		+werbespruch+"', :regulatedProductName => '"
		+sorte+"', :regulatedProductNameEN => '"
		+sorteEN+"', :productInformationLink => '"
		+infourl+"', :imageLink => '"
		+bildurl+"', :ingriedientStatement => '"
		+inhaltsangabe+"', :ingriedientName => '"
		+inhaltsstoffe+"', :percentageOfAlcoholByVolume => "+alkg;
};

function neu(){
		document.getElementById('gtin').value = "02865195100014"; 
		document.getElementById('variante').value = "Duff Klassisch";
		document.getElementById('name').value = "Pils";
		document.getElementById('nameEN').value = "Pils";
		document.getElementById('werbespruch').value = "Duff Bier für, Duff Bier für dich, ich trinke Duff, ganz genüsslich.";
		document.getElementById('sorte').value = "Untergäriges Bier";
		document.getElementById('sorteEN').value = "Bottom-fermented beer";
		document.getElementById('alkoholgehalt').value = "5";
		document.getElementById('inhaltsstoffe').value = "Pilsener Malz Wyeast Hefe Hallertaler Magnum Hallertaler Perle";
		document.getElementById('inhaltsangabe').value = "Malz und Hopfen und so";
		document.getElementById('bildurl').value = "http://example.com/duff.jpg";
		document.getElementById('infourl').value = "http://example.com/duff";
}

function array(){
		console.log("Test");
		var gtin = document.getElementById('gtin').value;
		var variante = document.getElementById('variante').value;
		var name = document.getElementById('name').value;
		var nameEN = document.getElementById('nameEN').value;
		var werbespruch = document.getElementById('werbespruch').value;
		var sorte = document.getElementById('sorte').value;
		var sorteEN = document.getElementById('sorteEN').value;
		var alkg = document.getElementById('alkoholgehalt').value;
		var inhaltsstoffe = document.getElementById('inhaltsstoffe').value;
		var inhaltsangabe = document.getElementById('inhaltsangabe').value;
		var bildurl = document.getElementById('bildurl').value;
		var infourl = document.getElementById('infourl').value;
		
		var result = [gtin,variante,name,nameEN,werbespruch,sorte,sorteEN,alkg,inhaltsstoffe,inhaltsangabe,bildurl,infourl];
		console.log("Test");	
}