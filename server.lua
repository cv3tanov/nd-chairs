local NDCore = exports['nd-core']:GetCoreObject()
local chairs = {}

CreateThread(function()
	for i=1, 110, 1 do
		chairs[#chairs+1] = "chair"..i
	end
    for k,v in pairs(chairs) do
       NDCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('nd-chairs:Use', source, item.name) end)
	end
end)
