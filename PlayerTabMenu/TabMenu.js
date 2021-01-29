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

function SetPlayerMax(Value){
    Alert("12")
    document.getElementById("PlayerMax").innerHTML = "/" + Value;
}

function SetCopMax(Value){
    Alert("12")
    document.getElementById("copMax").innerHTML = "/" + Value;
}

function SetSoldierMax(Value){
    Alert("12")
    document.getElementById("soldierMax").innerHTML = "/" + Value;
}

function SetDoctorMax(Value){
    Alert("12")
    document.getElementById("doctorMax").innerHTML = "/" + Value;
}

function SetFixMaxMax(Value){
    Alert("12")
    document.getElementById("fixMax").innerHTML = "/" + Value;
}


function SetPlayerNbr(Value){
    Alert(Value)
    document.getElementById("PlayerNbr").innerHTML = Value;
}

function SetCopNbr(Value){
    Alert(Value)
    document.getElementById("copNbr").innerHTML = Value;
}

function SetSoldierNbr(Value){
    Alert(Value)
    document.getElementById("soldierNbr").innerHTML = Value;
}

function SetDoctorNbr(Value){
    Alert(Value)
    document.getElementById("doctorNbr").innerHTML = Value;
}

function SetFixMaxNbr(Value){
    Alert(Value)
    document.getElementById("fixNbr").innerHTML = Value;
}