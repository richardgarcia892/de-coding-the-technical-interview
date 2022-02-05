function attempt_to_award_random_magical_item(context)
	-- don't award a magical item if it is a quest battle
	local a_char_cqi, a_mf_cqi, a_faction_name = cm:pending_battle_cache_get_attacker(1);
	local d_char_cqi, d_mf_cqi, d_faction_name = cm:pending_battle_cache_get_defender(1);
	
	local attacker = cm:get_faction(a_faction_name);
	local defender = cm:get_faction(d_faction_name);
	
	if (attacker and attacker:is_quest_battle_faction()) or (defender and defender:is_quest_battle_faction()) then
		out.traits("attempt_to_award_random_magical_item() called, but it is a quest battle. Not going to award anything.");
		return;
	end;
	
	local index = 0;
	
	local character = context:character();
	local faction = character:faction();
	
	if faction:subculture() ~= "wh_main_sc_dwf_dwarfs" and (character:is_caster() or general_has_caster_embedded_in_army(character)) then
		index = cm:random_number(7); -- this will weigh slightly towards arcane items when the character is a caster (6 or higher)
	else
		index = cm:random_number(5); -- don't drop arcane items if the character involved is not a caster
	end;
	
	local new_ancillary_list = {};
	
	if index == 1 then
		new_ancillary_list = ancillary_list.armour;
	elseif index == 2 then
		new_ancillary_list = ancillary_list.enchanted_item;
	elseif index == 3 then
		new_ancillary_list = ancillary_list.banner;
	elseif index == 4 then
		new_ancillary_list = ancillary_list.talisman;
	elseif index == 5 then
		new_ancillary_list = ancillary_list.weapon;
	else
		new_ancillary_list = ancillary_list.arcane_item;
	end;
	
	-- get the list of ancillaries based on the rarity
	local rarity_roll = cm:random_number(100);
	
	if rarity_roll > 59 then
		new_ancillary_list = new_ancillary_list.rare;
	elseif rarity_roll > 29 then
		new_ancillary_list = new_ancillary_list.uncommon;
	else
		new_ancillary_list = new_ancillary_list.common;
	end;
	
	local pb = context:pending_battle();
	local model = pb:model();
	local campaign_difficulty = model:difficulty_level();
	local chance = 100;
	local bv_chance = character:post_battle_ancillary_chance();
	
	-- mod the chance based on the bonus value state
	chance = chance + bv_chance;
	
	-- mod the chance based on campaign difficulty (only if singleplayer)
	if model:is_multiplayer() then
		-- in mp, modify as if playing on normal difficulty
		chance = chance + 6;
	elseif faction:is_human() then							-- player
		if campaign_difficulty == 1 then					-- easy
			chance = chance + 8;
		elseif campaign_difficulty == 0 then				-- normal
			chance = chance + 6;
		elseif campaign_difficulty == -1 then				-- hard
			chance = chance + 4;
		elseif campaign_difficulty == -2 then				-- very hard
			chance = chance + 2;
		end;
	else													-- AI
		if campaign_difficulty == 0 then					-- normal
			chance = chance + 2;
		elseif campaign_difficulty == -1 then				-- hard
			chance = chance + 4;
		elseif campaign_difficulty == -2 then				-- very hard
			chance = chance + 6;
		else												-- legendary
			chance = chance + 8;
		end;
	end;
	
	-- mod the chance based on victory type
	if pb:has_attacker() and pb:attacker() == character then
		if pb:attacker_battle_result() == "close_victory" then
			chance = chance + 2;
		elseif pb:attacker_battle_result() == "decisive_victory" then
			chance = chance + 4;
		elseif pb:attacker_battle_result() == "heroic_victory" then
			chance = chance + 6;
		end;
	elseif pb:has_defender() then
		if pb:defender_battle_result() == "close_victory" then
			chance = chance + 2;
		elseif pb:defender_battle_result() == "decisive_victory" then
			chance = chance + 4;
		elseif pb:defender_battle_result() == "heroic_victory" then
			chance = chance + 6;
		end;
	end;
	
	if chance > 100 then
		chance = 100
	end;
	
	-- tomb kings chance is cut in half due to mortuary cult
	if faction:culture() == "wh2_dlc09_tmb_tomb_kings" then
		chance = chance * 1;
	end;
	
	local roll = cm:random_number(100);
	
	if core:is_tweaker_set("FORCE_ANCILLARY_DROP_POST_BATTLE") then
		roll = 1;
	end;
	
	out.traits("Rolled a " .. roll .. " to assign an ancillary with a chance of " .. chance .. " for a character belonging to the faction " .. faction:name());
	
  chance = 100
  roll = 0
	if roll <= chance then
		local can_equip = false;
		local count = 0;
		
		while not can_equip and count < 20 do
			local ancillary_index = cm:random_number(#new_ancillary_list);
			local chosen_ancillary = new_ancillary_list[ancillary_index];
			
			count = count + 1;
			
			if character:can_equip_ancillary(chosen_ancillary) then
				can_equip = true;
				out.traits("Trying to assign the ancillary " .. chosen_ancillary .. " for a character belonging to the faction " .. faction:name());
				effect.ancillary(chosen_ancillary, 100, context);
			end;
		end;
	end;
end;
