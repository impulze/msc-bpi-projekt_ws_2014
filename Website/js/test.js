
var add = function(){
		console.log("Test");

		var name = document.getElementById('name').value;
		var sorte = document.getElementById('sorte').value;
		var beschr = document.getElementById('beschreibung').value;
		var alkg = document.getElementById('alkoholgehalt').value;
		var alk = document.getElementById('alkohol').value;

		if(alk=="Ohne Alkohol")
		{	
				document.getElementById('area').value ="Name: "+name+" | Sorte: "+sorte+" | Beschreibung: "+beschr+" und Alkoholfrei" ;
		}
		else
		{
				document.getElementById('area').value ="Name: "+name+" | Sorte: "+sorte+" | Beschreibung: "+beschr+" | Alkoholgehalt: "+alkg+"%" ;
		}
		
};

function neu(){
	document.getElementById("name").value = "";
	document.getElementById("sorte").value = "";
	document.getElementById("beschreibung").value = "";
	document.getElementById("alkoholgehalt").value = "";
	document.getElementById("alkohol").value = "Mit Alkohol";
	document.getElementById("area").value = "";
}
