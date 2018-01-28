--[[
original code provided by tenplus1
This mod instigates an effective border for new players joining a server
with persistence of the last state across server restarts
]]

local mod_data = minetest.get_mod_storage()
local border = "OPEN"

-- initialise
if mod_data:get_string("status") == "" then
  mod_data:set_string("status", "CLOSED") 
end

--set
border = mod_data:get_string("status")

-- announce status
minetest.after(5, function()
	minetest.chat_send_all("[border:info] border is "..border)
end)

-- toggle new players
minetest.register_chatcommand("border", {
    params = "",
    description = "Toggles if new players are allowed",
    privs = {server = true},
    func = function (name, param)
      if border == "CLOSED" then
        border = "OPEN"
        minetest.chat_send_player(name, "[border:info] allowing new players.")
      else
        border = "CLOSED"
        minetest.chat_send_player(name, "[border:info] refusing new players.")
      end
      mod_data:set_string("flag", border) -- save
    end
  })

-- register hook
minetest.register_on_prejoinplayer(function(name, ip)
	-- owner exception
	if minetest.setting_get("name") == name then
			return
	end
	-- stop NEW players from joining
	local player = minetest.get_auth_handler().get_auth(name)
	if border == "CLOSED" and not player then
			return ("\nSorry, no new players being admitted at this time!")
	end
end
)
