ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("esx_hotwire:isOwner", function (source, cb, plate)
    local _source = source
    local identifier = ESX.GetPlayerFromId(_source).getIdentifier()
    MySQL.Async.fetchAll('SELECT * FROM `owned_vehicles` WHERE `plate` = @plate', {['@plate'] = plate}, function(result)
        cb(result[1]~=nil and result[1].owner==identifier)
    end)
end)

ESX.RegisterServerCallback("esx_hotwire:hotwire", function (source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local item = xPlayer.getInventoryItem("lockpick")
    if item.count>0 then
        cb(true)
        Citizen.CreateThread(function()
            Citizen.Wait(cfg.hotwiretime*1000)
            local chance = math.random(100)
            if chance <= cfg.lockpickbreakchance then
                xPlayer.removeInventoryItem("lockpick",1)
                TriggerClientEvent("esx:showNotification",_source,"~r~Your "..item.label.." broke!")
            end
        end)
    else
        TriggerClientEvent("esx:showNotification",_source,"~r~You don't have any lockpicks!")
    end
end)