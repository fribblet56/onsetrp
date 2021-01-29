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

function SetPoint(Value){
    document.getElementById("Point").innerHTML = Value;
}

function SetLimitKmh(Value){
    document.getElementById("Kmh").innerHTML = Value;
}

function SetPickup(Value){
    document.getElementById("Pickup").innerHTML = Value + "/";
}