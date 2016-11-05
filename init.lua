combat_tags = {}

minetest.register_on_leaveplayer(function(objref, timeout)
	if timeout then
		minetest.chat_send_all(objref:get_player_name().." timed out while combat tagged. Items were not dropped.")
		combat_tags[objref:get_player_name()] = false
	end
	if combat_tags[objref:get_player_name()] then
		minetest.chat_send_all(objref:get_player_name().." logged out while combat tagged at x: "..math.floor(objref:getpos().x)..", y: "..math.ceil(objref:getpos().y)..", z: "..math.floor(objref:getpos().z).."!")
		objref:set_hp(0)
		combat_tags[objref:get_player_name()] = false
	end
end)

minetest.register_on_punchplayer(function(player, hitter)
	if not hitter and player then
		return false
	end
	if hitter:get_player_name() == "" or player:get_player_name() == "" then
		return false
	end
	if not combat_tags[player:get_player_name()] then
		combat_tags[player:get_player_name()] = true
		minetest.chat_send_player(player:get_player_name(), minetest.colorize("#FF4F00", "You have been combat tagged by "..hitter:get_player_name()..". If you log out in the next 15 seconds, you will die and your inventory will be dropped."))
		minetest.after(15, function()
			if player then
				minetest.chat_send_player(player:get_player_name(), minetest.colorize("#007F00", "You can now safely log out."))
				combat_tags[player:get_player_name()] = false
			end	
		end)
	end
end)
