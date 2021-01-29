isCreated = false

function initWelcome(created) {
    if (created) {
    	isCreated = true
    } else {
    	isCreated = false
    }
}

function button(){
	if(isCreated){
		window.ue.game.callevent("CloseAndSpawn", "[]");
	}else{
		window.ue.game.callevent("CloseAndCreateCharacter", "[]");
	}
}

function PlayerMax(_PlayerMax){
	document.getElementById("PlayerMax").innerHTML = _PlayerMax;
}

function PlayerNumber(_PlayerNumber){
	document.getElementById("PlayerNumber").innerHTML = _PlayerNumber;
}

function PlayerName(_PlayerName){
	document.getElementById("PlayerName").innerHTML = "Pseudo en jeu: "+_PlayerName;
}

function PlayerPseudo(_PlayerPseudo){
	document.getElementById("PlayerPseudo").innerHTML = _PlayerPseudo;
}

function PlayerSteamId(_PlayerSteamId){
	document.getElementById("PlayerSteamId").innerHTML = "Votre SteamId: "+_PlayerSteamId;
}

function PlayerId(_PlayerId){
	document.getElementById("PlayerId").innerHTML = "Votre Id: "+_PlayerId;
}

function PlayTime(_Time){

	h = _Time / 60

	document.getElementById("PlayerJob").innerHTML = "Heure(s) de jeu: "+parseInt(h)+"H";
}
