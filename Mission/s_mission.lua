local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local MissionList = {
	{ -- Mission Du Donut Sacrée
        Id = 1,
        Message = {
            npc = "Policier",
            title = "Le Donut Sacré",
            description = "Bonjour ! Je suis embêté, je trouve plus mon donut, c'est encore un de mes collègues qui a du me le voler, j'ai vraiment besoin de ça pour me concentrer, tu pourrais aller m'en acheter un s'il te plaît ? Fais attention en revenant, les autres policiers n'hésiterons pas à te le prendre s'ils te voient avec un donut !",
            start = "Ouai pourquoi pas, après tout, manger c'est sacré !",
            finish = "Tiens voila ton donut, fais attention la prochaine fois !",
            alreadydone = "Encore merci pour le gâteau !"
        },
        NpcLocation = { 
            x = 170854, 
            y = 193805, 
            z = 1397, 
            h = 172
        },
        reward = {
            cash = 3000,
            item = ""
        },
        require_object = {
        	spawn = false,
            objectID = 49,
            title = "donut",
            amount = 1,
            item_name = "donut",
            x = 0,
            y = 0,
            z = 0
        },
        NpcId = {}
    },
    { --Mission dealer
        Id = 2,
        Message = {
            npc = "Dealer",
            title = "La boisson c'est essentiel",
            description = "Salut mec ! Tu cherches un truc, j'ai toute sorte de produits, ah t'as déja tout c'qui te faut okay, dis moi mon gros tu pourrais me rendre un service ? Je passe ma journée à bicrave ici, le boss me surveille je peux même pas aller me chercher une boisson, j'ai trop soif à force de bédave tu vois, ça t'ennuie d'me ramener un truc à boire, de l'eau ça fera l'affaire, t'assure si tu m'ramènes ça !",
            start = "Y'a pas de soucis j'te ramènes ça.",
            finish = "Tiens j'en ai pris deux !",
            alreadydone = "Salut poto fais gaffe aux flics ils tournent pas mal dans le coin"
        },
        NpcLocation = { 
            x = 159689, 
            y = 220992, 
            z = 1310, 
            h = -130
        },
        reward = {
            cash = 0,
            item = "weed"
        },
        require_object = {
            spawn = false,
            objectID = 47,
            title = "water_bottle",
            amount = 1,
            item_name = "water_bottle",
            x = 0,
            y = 0,
            z = 0
        },
        NpcId = {}
    },
    { --La pute
        Id = 3,
        Message = {
            npc = "Felicity",
            title = "L'outil fais le travail",
            description = "Salut mon chou ! Hey dis moi t'aurais pas des menottes sur toi ? J'ai un soucis avec un client spécial qui bosse pour le gouvernement, tu vois le genre de gros poisson qui rapporte un max mais qui demande toujours des trucs chelou, ramènes moi ça et mon mac te fileras c'qui faut en cash.",
            start = "C'est pas facile à trouver mais je vais essayer.",
            finish = "Voila tes menottes ma belle.",
            alreadydone = "Hey mon chou hésites pas à passer je te ferais un prix spécial pour te remercier !"
        },
        NpcLocation = { 
            x = 48295, 
            y = 139554, 
            z = 1575, 
            h = 78
        },
        reward = {
            cash = 12000,
            item = ""
        },
        require_object = {
            spawn = false,
            objectID = 88,
            title = "Menottes",
            amount = 1,
            item_name = "handcuffs",
            x = 0,
            y = 0,
            z = 0
        },
        NpcId = {}
    },
    {
        Id = 4,
        Message = {
            npc = "Gangsta",
            title = "Guerre de gangs",
            description = "Yo mec bien ou quoi, t'aurais deux minutes pour parler d'un truc ? Tu dois connaître le gang à l'ouest de la ville qui vend d'la beuh partout dans le centre, écoutes bien, on va leur faire la peau bientôt, moi et mes frères on va leur tomber dessus et tous les fumer, ils nous font chier depuis qu'ils sont là ils foutent la merde partout. Le truc c'est que j'ai perdu mon flingue au casino, bref j'peux pas le dire à mes potes sinon ils vont me prendre la tête, t'es chaud de me ramener un Colt 1911 histoire que je puisse plomber tout ces chacals ? T'inquiètes j'te mettrais bien si tu me rends ce service.",
            start = "Je vais voir c'que je peux faire.",
            finish = "Voila ton arme, fais gaffe quand même !",
            alreadydone = "T'es un vrai soldat, prends garde à toi mon gars, à plus tard !"
        },
        NpcLocation = { 
            x = 152464, 
            y = 200445, 
            z = 363, 
            h = -86
        },
        reward = {
            cash = 20000,
            item = "cannabis_oil"
        },
        require_object = {
            spawn = false,
            objectID = 58,
            title = "Colt 1911",
            amount = 1,
            item_name = "weapon_3",
            x = 0,
            y = 0,
            z = 0
        },
        NpcId = {}
    },
    {
        Id = 5,
        Message = {
            npc = "Mr Smith",
            title = "L'affaire du siècle",
            description = "B'jour m'sieur vous habitez dans le coin ? Ah non, je me disais bien aussi je vous ai jamais vu, vous allez pas me croire mais je suis comment dire..euh enfermer dehors ! Oui c'est ça, ma femme est partis en fermant la porte à clés, et hum.. je suis bloquer dehors haha.. , c'est une situation délicate mais j'me demandais uh uh.. , vous auriez pas un lockpick sur vous a tout hasard ? J'avoue ça m'aiderait bien..",
            start = "Hum.. okay je vais voir..",
            finish = "Voila ce que vous cherchiez.. à bientôt.. j'imagine",
            alreadydone = "Merci encore l'ami.."
        },
        NpcLocation = { 
            x = 199293, 
            y = 170295, 
            z = 1306, 
            h = 165
        },
        reward = {
            cash = 10000,
            item = ""
        },
        require_object = {
            spawn = false,
            objectID = 52,
            title = "lockpick",
            amount = 1,
            item_name = "lockpick",
            x = 0,
            y = 0,
            z = 0
        },
        NpcId = {}
    },
    {
        Id = 6,
        Message = {
            npc = "Jack le SDF",
            title = "Le magicien",
            description = "Kuf kuf huufrf.. huum t'es qui toi ? Encore un d'ces chiens du gouvernement c'est ça ?! Aah huum t'as d'quoi boire un coup avec toi ? Putain mais t'es inutile...eurf.. yup tu vois le cheval là bas ? Hey s'moi qui l'ai invoqué mec..hehe.. j'suis un putain de magicien.. écoutes gamin, rends service à la communauté en m'ram'nant un truc pratique tu vois, genre un kit de soin, t'sais ceux avec des seringues de morphine..ouai.. ramènes moi ça et j'te filerais euh.. un trésor.. ouai, une pierre magique mon p'tit gars tu vas flipper..haha hu hu kuurf erf..hum grouille toi..",
            start = "Okay mec..",
            finish = "Voila ton kit, tu devrais quand même voir un médecin je pense..",
            alreadydone = "Hahaha il va pleuvoir aujourd'hui.. t'es qui toi ?!"
        },
        NpcLocation = { 
            x = 220023, 
            y = 115986, 
            z = 1418, 
            h = 147
        },
        reward = {
            cash = 0,
            item = "iron_ore"
        },
        require_object = {
            spawn = false,
            objectID = 51,
            title = "kit de soin",
            amount = 1,
            item_name = "health_kit",
            x = 0,
            y = 0,
            z = 0
        },
        NpcId = {}
    },
    {
        Id = 7,
        Message = {
            npc = "Frank Fort",
            title = "Le Faussaire",
            description = "Salut mon grand, j’ai laisser jouer mon gamin avec mon chalumeau, mais il a réussi a me le perdre, si tu me le trouve, je te donnerais une de mes vielle machine !",
            start = "J’ai un peut de temps devant moi je veux bien essayer !",
            finish = "C’est sa que tu cherche ?",
            alreadydone = "Alors bientôt riche ?"
        },
        NpcLocation = { 
            x = 112448, 
            y = 84546, 
            z = 1407, 
            h = 102
        },
        reward = {
            cash = 0,
            item = "money_printer"
        },
        require_object = {
            spawn = true,
            objectID = 1081,
            title = "Chalumeau",
            amount = 1,
            item_name = "blowtorch",
            x = 104023,
            y = 81715,
            z = 1343
        },
        NpcId = {}
    },
    {
        Id = 8,
        Message = {
            npc = "Gangsta",
            title = "Pablito Loslocos",
            description = "Vous aussi vous avez été parachuté par un fou furieux et avez fini sur cette île déserte ? Moi ça fait déjà... je ne sais même plus depuis combien de temps je suis bloqué ici, tout ce que je sais, c'est que les poissons qui me nourissent se font de plus en plus rare autour de cette île, et je commence à devenir fou tellement le sucre me manque, je donnerais tout ce que j'ai encore en ma possession pour la douceur d'un fruit, comme une pèche par exemple, vraiment, mon royaume pour une pèche toute douce et juteuse. ",
            finish = "Mais pourquoi est-ce que tu ... laisse tomber je vais chercher ça. ",
            alreadydone = "Où est ce que t'as trouvé ça ! En tout cas mille merci tiens prends-ça, chose promie, chose due, maintenant prochaine étape, trouver des cailloux pour former un SOS sur l'île dans l'espoir d'être retrouvés un jour..."
        },
        NpcLocation = { 
            x = 227905, 
            y = -67891, 
            z = 100, 
            h = 15
        },
        reward = {
            cash = 8000,
            item = "kit de soin"
        },
        require_object = {
            spawn = false,
            objectID = 0,
            title = "Pèche",
            amount = 1,
            item_name = "peach",
            x = 0,
            y = 0,
            z = 0
        },
        NpcId = {}
    },
    {
        Id = 9,
        Message = {
            npc = "Markus Persson",
            title = "Markus Persson",
            description = "Toi aussi t'es fan de minecraft ? Comment ça c'est pour les enfants ! Tu fais quoi toi ? Du RP ??? C'est pire, je les ai vues les vidéos de Garry's Mod et compagnie ! C'est pas du tout à ce jeu que tu joues ? Mouais.. Enfin bref, moi je me rends à une convention là, mais j'ai totalement oublié ma pioche à la maison et si je me ramène là bas comme ça, j'vais passer pour un con, tout le monde est déguisé là bas, du coup si t'as une pioche sur toi, je suis prêt à te l'acheter dix fois son prix. Comment ça c'est pas assez t'as cru que j'étais milliardaire ? Après tu me diras, je le suis peut-être qui sait, bon allez, je te l'achète vingt fois son prix, et là c'est ma dernière offre !  ",
            finish = "Tiens ta pioche tête de pioche.",
            alreadydone = "Je sais pas si je dois te remercier, mais tiens prends les sous, moi y'a Kevin qui m'attend pour aller prendre des selfies avec les cosplayeuses déguisées en herobrine. "
        },
        NpcLocation = { 
            x = 193376, 
            y = 175754, 
            z = 1226, 
            h = -59
        },
        reward = {
            cash = 6000,
            item = ""
        },
        require_object = {
            spawn = false,
            objectID = 1063,
            title = "Pioche",
            amount = 1,
            item_name = "pickaxe",
            x = 0,
            y = 0,
            z = 0
        },
        NpcId = {}
    },
    {
        Id = 10,
        Message = {
            npc = "Un roux",
            title = "Aaron Yesmilk",
            description = "Excusez moi je vous dérange pas ? J'aurais besoin d'un coup de main, à vrai dire hier soir je faisais la fête avec des amis à moi quand je me suis isolé avec l'un d'entre eux pour prendre un peu de poudre magique histoire de pimenter la soirée car je me faisais chier avec les deux autres blaireaux, bref, le problème est qu'après avoir pris la poudre magique, je me souviens juste qu'on est complétement partis en vrille dans notre tête, on a quittés la soirée et on est partis faire les cons en ville, le problème c'est que j'ai un gros blackout sur ce qu'il s'est passés ensuite, tout ce que je sais, c'est que je me suis réveillé seul et que personne sait où est passé mon pote, vous pourriez m'aider à le retrouver ? C'est une personne assez importante et le groupe ne voudra pas me parler tant que je ne l'aurais pas retrouvé... Merci d'avance. ",
            start = "Je te retiens au jus si je le trouve",
            finish = "C'est bien de lui que tu parlais ?",
            alreadydone = "Ah tu me sauves la vie, tiens je te donne ça j'en ai plus besoin de toute façon, et un conseil, si Bertie Crochet te propose de la poudre n'en prends pas ça rend zinzin ! "
        },
        NpcLocation = { 
            x = 180921, 
            y = 182418, 
            z = 1290, 
            h = 151
        },
        reward = {
            cash = 1000,
            item = "item_backpack"
        },
        require_object = {
            spawn = true,
            objectID = 477,
            title = "Choixpeau magique",
            amount = 1,
            item_name = "magic_hat",
            x = 189759,
            y = 195516,
            z = 1316
        },
        NpcId = {}
    },
    {
        Id = 11,
        Message = {
            npc = "Pêcheur",
            title = "Hareng placé !",
            description = "B'jour m'sieur z'etes occupé ? En gros j'ai un p'tit soucis de matos, ma canne à pêche est complètement foutu à cause des requins et autres saletés qui pullulent dans l'eau, j'suis même sûr que c'est encore un coup des sirènes.. si j'les attrapent j'les louperais pas cette fois ci ! En attendant tu crois qu'tu pourrais aller me chercher une autre canne, aller s'teuplait...",
            start = "Okay j'vais voir ça !",
            finish = "Tiens vieil homme, voila ta canne.",
            alreadydone = "Hehehe.. merci"
        },
        NpcLocation = { 
            x = 232476, 
            y = 195049, 
            z = 402, 
            h = -177
        },
        reward = {
            cash = 1500,
            item = "hareng"
        },
        require_object = {
            spawn = false,
            objectID = 56,
            title = "Canne à pêche",
            amount = 1,
            item_name = "fishing_rod",
            x = 0,
            y = 0,
            z = 0
        },
        NpcId = {}
    },
    {
        Id = 12,
        Message = {
            npc = "Chauffeur",
            title = "L'or noir",
            description = "Hey toi là ! Excuse moi d'te déranger j'ai un soucis, je dois faire une..euh une livraison un peu spéciale, et j'ai plus d'essence ! Assures et ramènes moi un jerrican rempli, j'dois reprendre la route au plus vite sinon les fli.. hum.. sinon le client risque d'être mécontent.. si tu te dépêche j'te revaudrais ça !",
            start = "Euh oui bien sûr pas de problème.",
            finish = "Voila ton jerrican",
            alreadydone = "Merci, tu m'as évité pas mal de soucis !"
        },
        NpcLocation = { 
            x = 211452, 
            y = 92786, 
            z = 1380, 
            h = 178
        },
        reward = {
            cash = 5000,
            item = ""
        },
        require_object = {
            spawn = false,
            objectID = 55,
            title = "jerican",
            amount = 1,
            item_name = "jerican",
            x = 0,
            y = 0,
            z = 0
        },
        NpcId = {}
    },
    {
        Id = 13,
        Message = {
            npc = "Soldat",
            title = "La guerre de l'ombre",
            description = "A l'aide ! Quelqu'un s'il vous plaît..keurf urf ! M'sieur vous là ! S'il vous plaît aider moi, j'suis salement blessé...erf, je suis militaire à Viceland..argh..et j'ai perdu tout contact avec mon unité après un accrochage avec ces sale rebelles, essayez de trouver un kit de soin,...rapidement.. j'vais pas tenir une heure de plus je crois..",
            start = "Okay monsieur je me dépêche !",
            finish = "Voila votre kit de soin j'espère que ça suffira !",
            alreadydone = "Merci pour tout, vous m'avez sauvé"
        },
        NpcLocation = { 
            x = 200299, 
            y = 82504, 
            z = 1539, 
            h = -14
        },
        reward = {
            cash = 3000,
            item = "survival_ration"
        },
        require_object = {
            spawn = false,
            objectID = 51,
            title = "health kit",
            amount = 1,
            item_name = "health_kit",
            x = 0,
            y = 0,
            z = 0
        },
        NpcId = {}
    },
    {
        Id = 14,
        Message = {
            npc = "Scientifique",
            title = "Les besoins de la science",
            description = "Bonjour cher monsieur... Comment aller vous aujourd'hui ? Vous m'avez l'air d'une personne très compétente, vous pourriez peut-être m'aider pour mes recherches.. voyez-vous je suis un scientifique de renom, mais mon travail est...hum..comment dire... je suis parfois incompris par mes pairs, c'est pourquoi je m'isole pour avancer dans mes travaux.. malheureusement il me manque certaines choses, seriez-vous capable de me ramener une seringue d'adrénaline, j'ai un problème avec un.. patient... je saurais me montrer généreux.. ",
            start = "Okay je vais essayer..",
            finish = "Voila votre seringue Doc'",
            alreadydone = "Haha parfait..oui c'est excellent.."
        },
        NpcLocation = { 
            x = 179960, 
            y = 10621, 
            z = 10394, 
            h = 159
        },
        reward = {
            cash = 8000,
            item = ""
        },
        require_object = {
            spawn = false,
            objectID = 91,
            title = "Adrenaline syringe",
            amount = 1,
            item_name = "adrenaline_syringe",
            x = 0,
            y = 0,
            z = 0
        },
        NpcId = {}
    },
    {
        Id = 15,
        Message = {
            npc = "SDF",
            title = "La bourse ou la vie",
            description = "Haha...ha qu'es tu m'veux toi là ? C'est Jack qui t'envoie ?! J'vais tous vous buter arf..kerf.. quoi non t'es pas avec eux ? Ah t'es qu'un gamin..arrgh..tu sais..vivre dans la rue c'est chaud.. ils m'ont pété la clavicule j'crois.. les enfoirés.. écoutes gamin.. vas m'chercher un truc pour me défendre..hum.. genre une pioche, j'vais faire une descente chez ces salauds, on va voir qui c'est le plus malin..",
            start = "Euh okay..",
            finish = "Tenez votre pioche m'sieur, vous devriez peut-être consulter un médecin..",
            alreadydone = "J'vais pas m'laisser prendre c'qui m'appartient !"
        },
        NpcLocation = { 
            x = 164026, 
            y = 207096, 
            z = 1302, 
            h = 15
        },
        reward = {
            cash = 25,
            item = "hareng"
        },
        require_object = {
            spawn = false,
            objectID = 53,
            title = "pickaxe",
            amount = 1,
            item_name = "pickaxe",
            x = 0,
            y = 0,
            z = 0
        },
        NpcId = {}
    },
    {
        Id = 16,
        Message = {
            npc = "Gangsta",
            title = "Chacun sa guerre",
            description = "Salut mec.. viens voir par là.. c'est la première fois que j'te vois dans le coin.. t'as pas l'air d'être d'un gang, tu peux ptete m'aider, j'ai une embrouille avec les gars qui tiennent le sud de la ville, ils viennent jusqu'à chez ma famille c'est chaud.. j'peux plus laisser couler ça, j'vais aller les choper dans la boite sur la plage, j'sais qu'ils se posent là-bas le soir.. le soucis c'est que les armes à feu sont interdites, ramènes moi une hache et j'vais faire un carnage sur place, ça devrait régler mes histoires si je fais une belle boucherie..",
            start = "C'est un peu excessif mais pourquoi pas !",
            finish = "Voila ton matos, bonne chance !",
            alreadydone = "Merci mec t'as assuré"
        },
        NpcLocation = { 
            x = 141075, 
            y = 207322, 
            z = 1292, 
            h = 175
        },
        reward = {
            cash = 2500,
            item = "weed"
        },
        require_object = {
            spawn = false,
            objectID = 83,
            title = "lumberjack_axe",
            amount = 1,
            item_name = "lumberjack_axe",
            x = 0,
            y = 0,
            z = 0
        },
        NpcId = {}
    },
    {
        Id = 17,
        Message = {
            npc = "Mineur d'or",
            title = "L'eau c'est la vie ?",
            description = "Vous là ! Ah parfait, écoutez monsieur j'suis un peu embêté, j'étais venu miner dans le coin pour quelques jours, mais j'ai zapper mon eau ! J'aurais vraiment besoin que vous me rameniez ça si vous pouvez, je peux pas me permettre de partir maintenant, l'or n'attends pas !",
            start = "Vous avez vraiment pas l'air d'aller bien, je vous ramène ça rapidement !",
            finish = "Tenez m'sieur.",
            alreadydone = "Merci encore l'ami !"
        },
        NpcLocation = { 
            x = 82208, 
            y = -12531, 
            z = 2017, 
            h = -99
        },
        reward = {
            cash = 3500,
            item = "pickaxe"
        },
        require_object = {
            spawn = false,
            objectID = 47,
            title = "water bottle",
            amount = 1,
            item_name = "water_bottle",
            x = 0,
            y = 0,
            z = 0
        },
        NpcId = {}
    }
}

local MissionNpc = {}

AddEvent("OnPackageStart", function()
	for k,v in pairs(MissionList) do
		v.NpcId = CreateNPC(v.NpcLocation.x, v.NpcLocation.y, v.NpcLocation.z, v.NpcLocation.h )
    	CreateText3D(v.Message.title.."\n".._("press_e"), 18, v.NpcLocation.x, v.NpcLocation.y, v.NpcLocation.z  + 120, 0, 0, 0)
    	table.insert(MissionNpc, v.NpcId)
	end
end)

AddRemoteEvent("mission:UpdateMissionList", function ( player )
	CallRemoteEvent(player, "mission:UpdateMissionList_c", PlayerData[player].mission)
end)

AddEvent("OnPlayerSpawn", function(player)
	Delay(2000, function (  )
		CallRemoteEvent(player, "mission:Setup", MissionNpc, MissionList )
	end)
end)

AddRemoteEvent("mission:InteractNpc", function ( _player )
	local x, y, z = GetPlayerLocation(_player)
    for k, npcId in pairs(MissionNpc) do
        local x2, y2, z2 = GetNPCLocation(npcId)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)

        if dist < 250.0 then
            for k,i in pairs(MissionList) do
                if npcId == i.NpcId then
                    CallRemoteEvent(_player, "mission:OpenMission", i.Message, PlayerData[_player].mission, i.Id)
                end
            end
        end
    end
end)

AddRemoteEvent("mission:UpdateMissionStatu", function ( player, _MissionId, _MissionStatu )
    for k, v in pairs(PlayerData[player].mission) do

        if v.id == _MissionId then
            v.statue = _MissionStatu
        end

    end

    CallRemoteEvent(player, "mission:UpdateMissionList_c", PlayerData[player].mission)
end)

AddRemoteEvent("mission:PlayerEnd", function ( player, _id, _statue)

	for k,i in pairs(MissionList) do
		if i.Id == _id then
		    if PlayerData[player].inventory[i.require_object.item_name] or 0 >= 1 then

		        for k, v in pairs(PlayerData[player].mission) do

		            if v.id == _id then
		                v.statue = _statue
		            end

		        end

		        RemoveInventory(player, i.require_object.item_name, 1, 0, player)

		        if i.reward.item ~= "" then
			        AddInventory(player, i.reward.item, 1, player)
			    end

		        if i.reward.cash ~= "" then
			        AddPlayerCash(player, i.reward.cash)
			    end

		        CallRemoteEvent(player, "mission:OpenMission", i.Message, PlayerData[player].mission, i.Id)
		        CallRemoteEvent(player, "MakeSuccessNotification", "Mission accomplie Respect ++")
		        CallRemoteEvent(player, "PlayAudioFile", "mission-passed.mp3")

		    else
		    	CallRemoteEvent(player, "MakeErrorNotification", "Vous n'avez pas l'object demander.")
		    end
		end
	end

end)

AddRemoteEvent("mission:PlayerStart", function( _player, _MissionId )
	for k,v in pairs(MissionList) do
		if v.Id == _MissionId then
			if v.require_object.spawn ~= false then
				CreateMissionObj(
			        v.require_object.x,
			        v.require_object.y,
			        v.require_object.z,
			        v.require_object.objectID,
			        v.require_object.title,
			        v.require_object.amount,
			        v.require_object.item_name
		        )
		    end
	    end
	end
end)

AddRemoteEvent("mission:AddMissionToPlayer", function ( player, _id, _statue )

    local Mission = {
        id = _id,
        statue = _statue
    }

    table.insert(PlayerData[player].mission, Mission)
end)

function CreateMissionObj( x, y, z, ObjectID, text, amount, item)
    object = CreateObject(ObjectID, x, y, z - 100)
    textObj = CreateText3D(text.." x"..amount, 15, x, y, z, 0,0,0)
    SetObjectPropertyValue(object, "isitem", true, true)
    SetObjectPropertyValue(object, "collision", false, true)
    SetObjectPropertyValue(object, "item", item, true)
    SetObjectPropertyValue(object, "amount", amount, true)
    SetObjectPropertyValue(object, "textid", textObj)
end