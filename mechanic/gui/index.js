(function(obj) {
    ue.game = {};
    ue.game.callevent = function(name, ...args) {
        if (typeof name != "string") {
            return;
        }
        if (args.length == 0) {
            obj.callevent(name, "");
        } else {
            let params = [];
            for (let i = 0; i < args.length; i++) {
                params[i] = args[i];
            }
            obj.callevent(name, JSON.stringify(params));
        }
    };
})(ue.game);
CallEvent = ue.game.callevent;

function Setup(value){
	if(value == 1){
		document.getElementById("Statut").innerHTML = "Se changer.";
	}else{
		document.getElementById("Statut").innerHTML = "Prendre son service";
	}
}

function closeGui(){
	CallEvent("mechanic:Gui", "[]");
}

function jobStatut(){
	CallEvent("mechanic:changeStatut", "[]");
}