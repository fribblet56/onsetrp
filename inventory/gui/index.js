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

Id = 0
Cash = 0

function OpenGui(id, etat, battery, paper, money, statut){

    Cash = money
    Id = id

    if(statut == 1){
        document.getElementById("suplay").innerHTML = "Éteindre";
    }else{
        document.getElementById("suplay").innerHTML = "Allumer";
    }

    document.getElementById("balance").placeholder = money + "€";

    document.getElementById('paper-progress').setAttribute('aria-valuenow',paper);
    document.getElementById('paper-progress').setAttribute('style','width:'+Number(paper)+'%');
    document.getElementById("paper-progress").innerHTML = "Papier â "+ paper + "%";

     
    document.getElementById('battery-progress').setAttribute('aria-valuenow',battery);
    document.getElementById('battery-progress').setAttribute('style','width:'+Number(battery)+'%');
    document.getElementById("battery-progress").innerHTML = "Batterie â "+ battery + "%";

    document.getElementById('dommage-progress').setAttribute('aria-valuenow',etat);
    document.getElementById('dommage-progress').setAttribute('style','width:'+Number(etat)+'%');
    document.getElementById("dommage-progress").innerHTML = "Etat â "+ etat + "%";
}

function Withdraw(){
    CallEvent("printer:SetupWithdraw", Id, Cash);
}

function Repaire(){
    CallEvent("printer:SetupRepaire", Id);
}

function ChangeStatu() {
    CallEvent("printer:SetupChangeStatu", Id);
}

function ChangeBattery() {
    CallEvent("printer:SetupChangeBattery", Id);
}

function AddPaper() {
    CallEvent("printer:SetupPaper", Id);
}

function closeEditor(){
    CallEvent("closeEditor", "[]");
}

function Destroy(){
    CallEvent("printer:SetupDestroy", Id);
}