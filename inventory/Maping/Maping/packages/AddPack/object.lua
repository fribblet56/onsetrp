function OnPackageStart()
    local pakname = "arenemma"
    local res = LoadPak(pakname, "/arenemma/", "../../../OnsetModding/Plugins/arenemma/Content")
    res = ReplaceObjectModelMesh(43,"/arenemma/Arene_test_1")

    local pakname = "avion1"
    local res = LoadPak(pakname, "/avion1/", "../../../OnsetModding/Plugins/avion1/Content")
    res = ReplaceObjectModelMesh(45,"/avion1/avion1")

    local pakname = "borne_arcade"
    local res = LoadPak(pakname, "/borne_arcade/", "../../../OnsetModding/Plugins/borne_arcade/Content")
    res = ReplaceObjectModelMesh(52,"/borne_arcade/borne_arcade")

    local pakname = "camera_ip"
    local res = LoadPak(pakname, "/camera_ip/", "../../../OnsetModding/Plugins/camera_ip/Content")
    res = ReplaceObjectModelMesh(54,"/camera_ip/camera_ip")

    local pakname = "discoball"
    local res = LoadPak(pakname, "/discoball/", "../../../OnsetModding/Plugins/discoball/Content")
    res = ReplaceObjectModelMesh(49,"/discoball/discoball")

    local pakname = "escalier"
    local res = LoadPak(pakname, "/escalier/", "../../../OnsetModding/Plugins/escalier/Content")
    res = ReplaceObjectModelMesh(50,"/escalier/fbxStairs")

    local pakname = "helico_ferme_MG"
    local res = LoadPak(pakname, "/helico_ferme_MG/", "../../../OnsetModding/Plugins/helico_ferme_MG/Content")
    res = ReplaceObjectModelMesh(48,"/helico_ferme_MG/helico_ferme_MG")

    local pakname = "herbe"
    local res = LoadPak(pakname, "/herbe/", "../../../OnsetModding/Plugins/herbe/Content")
    res = ReplaceObjectModelMesh(44,"/herbe/grassy-groves-grass-tile_VRayFastFur")

    local pakname = "lavabo"
    local res = LoadPak(pakname, "/lavabo/", "../../../OnsetModding/Plugins/lavabo/Content")
    res = ReplaceObjectModelMesh(55,"/lavabo/lavabo")

    local pakname = "sacfrappe"
    local res = LoadPak(pakname, "/sacfrappe/", "../../../OnsetModding/Plugins/sacfrappe/Content")
    res = ReplaceObjectModelMesh(46,"/sacfrappe/sacfrappe")

    local pakname = "table"
    local res = LoadPak(pakname, "/table/", "../../../OnsetModding/Plugins/table/Content")
    res = ReplaceObjectModelMesh(51,"/table/table")

    local pakname = "tabouret"
    local res = LoadPak(pakname, "/tabouret/", "../../../OnsetModding/Plugins/tabouret/Content")
    res = ReplaceObjectModelMesh(53,"/tabouret/tabouret")

    local pakname = "tanka"
    local res = LoadPak(pakname, "/tanka/", "../../../OnsetModding/Plugins/tanka/Content")
    res = ReplaceObjectModelMesh(47,"/tanka/tanka")

    local pakname = "casqueduchantar"
    local res = LoadPak(pakname, "/casqueduchantar/", "../../../OnsetModding/Plugins/casqueduchantar/Content")
    res = ReplaceObjectModelMesh(402,"/casqueduchantar/casqueduchantar")
end
AddEvent("OnPackageStart", OnPackageStart)