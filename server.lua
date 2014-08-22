
function retrieveError(client, id, msg)
	local player = getPlayerName(client)

	if id and msg then
		for k, v in pairs(getElementsByType("player")) do
			if hasObjectPermissionTo(v, "function.kickPlayer", false) then
				outputChatBox("#FF0000[Error] #FFFFFF"..player:gsub("%x%x%x%x%x%x", "").." has recieved an error: "..id.." Message: "..msg, v, 0,0,0, true)
				--outputChatBox("#FFFFFF"..msg, v, 0,0,0, true)
			end
		end
		return true
	end
	return false
end


addEvent("retrieveError", true)
addEventHandler("retrieveError", getRootElement(), 
	function(id, msg)
		assert(type(id) == "string")
		assert(type(msg) == "string")

		return retrieveError(client, id, msg)
	end
)