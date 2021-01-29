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

function getPlaque(){
	var A = document.getElementById("Plaque1").value;
	var B = document.getElementById("Plaque2").value;
	var C = document.getElementById("Plaque3").value;

	var plaque = A+"-"+B+"-"+C
	CallEvent("GetWebDataChangePlate", plaque);
}

function getColors(){
	var newcolor = document.getElementById("color").value;
	CallEvent("GetWebDataChangeCarColor", newcolor);
}

function closeEditor(){
	CallEvent("closeEditor", "[]");
}