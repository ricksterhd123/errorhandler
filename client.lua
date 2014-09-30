
--------------------------------------------------
-- This is a redo of the type() function
-- with the possibility of multiple parameters.
--
-- Only returns true if all variables given are
-- the same type.
--------------------------------------------------
function mType(typ, ...) 
	if #arg == 0 or type(typ) ~= "string" then
		return false 
	end
	local i = 0
	for k, v in pairs(arg) do 
		if type(v) == typ then 
			i = i + 1 
		end 
	end 
	return (i == #arg) and true or false
end



local elements = {
	window = {0.37, 0.30, 0.25, 0.37, "An error has occured", true},
	button = {
		okayBut = {34, 242, 274, 26, "OKAY", false		},	-- 'OKAY' button, etc
	},

	memo = {26, 36, 292, 196, false},
}

-- g_errors is a list of errors that have been recorded and are sent to the server to get regulated.
local g_errors = {}

function sendError()
	if #g_errors == 0 then return false end
	local v = g_errors[#g_errors]
	local success = triggerServerEvent("retrieveError", getRootElement(), v.id, v.msg)
	if success then
		table.remove(g_errors)
		return true
	end

	assert(success)
end

local Error = {}


--------------------------------------------------
-- Desc: Create an error and allows multiple instances
-- of this gui.

-- Three parameters are needed, the error code
-- which is used to identify the error then
-- the message which is sent to the client which
-- isn't recorded within g_errors and the admin
-- error message which is necessary for a fix.
--------------------------------------------------
function Error:createAndDisplay(id, msgToClient, msgToAdmin, originateFromWindow)
	assert(mType("string", id, msgToClient, msgToAdmin))
	local oWindow = originateFromWindow or false

	local err = {}

	err.id = id
	err.msg = msgToAdmin
	table.insert(g_errors, err)

	local w = elements.window
	local b = elements.button.okayBut
	local m = elements.memo

	local window = guiCreateWindow(w[1], w[2], w[3], w[4], w[5], w[6])
		guiWindowSetSizable(window, false)
		guiSetProperty(window, "AlwaysOnTop", "True")
	local button = guiCreateButton(b[1], b[2], b[3], b[4], b[5], b[6], window)
		guiSetProperty(button, "NormalTextColour", "FFAAAAAA")
	local memo = guiCreateMemo(m[1], m[2], m[3], m[4], msgToClient, m[5], window)
		guiMemoSetReadOnly(memo, true)

	assert(window and button and memo, "Couldn't create gui")
	if not isCursorShowing() then showCursor(true) end

	addEventHandler("onClientGUIClick", button, 
		function()
			window:setVisible(false)
			if not oWindow and #g_errors < 2 then 
				showCursor(false)
			end
			destroyElement(window)
			sendError()
			err = nil
		end, false
	)

	return true
end

function createError(id, cMsg, sMsg)
	return Error:createAndDisplay(id, cMsg, sMsg)
end
