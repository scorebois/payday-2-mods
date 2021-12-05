function PlayerDamage:damage_fall(data)
	local damage_info = {
		result = {type = "hurt", variant = "fall"}
	}
	if self._god_mode or self._invulnerable or self._mission_damage_blockers.invulnerable then
		self:_call_listeners(damage_info)
		return
	elseif self:incapacitated() then
		return
	elseif self._mission_damage_blockers.damage_fall_disabled then
		return
	end
    local height_limit = 1000000000000
    local death_limit = 10000000000000
	if height_limit > data.height then
		return
	end
	local die = death_limit < data.height
	self._unit:sound():play("player_hit")
	managers.environment_controller:hit_feedback_down()
	managers.hud:on_hit_direction("down")
	if self._bleed_out then
		return
	end
	local health_damage_multiplier = 0
	if die then
		self._check_berserker_done = false
		self:set_health(0)
	else
		health_damage_multiplier = managers.player:upgrade_value("player", "fall_damage_multiplier", 1) * managers.player:upgrade_value("player", "fall_health_damage_multiplier", 1)
		self:change_health(-(tweak_data.player.fall_health_damage * health_damage_multiplier))
	end
	if die or health_damage_multiplier > 0 then
		local alert_rad = tweak_data.player.fall_damage_alert_size or 500
		local new_alert = {
			"vo_cbt",
			self._unit:movement():m_head_pos(),
			alert_rad,
			self._unit:movement():SO_access(),
			self._unit
		}
		managers.groupai:state():propagate_alert(new_alert)
	end
	local max_armor = self:_max_armor()
	if die then
		self:set_armor(0)
	else
		self:set_armor(self:get_real_armor() - max_armor * managers.player:upgrade_value("player", "fall_damage_multiplier", 1))
	end
	managers.hud:set_player_armor({
		current = self:get_real_armor(),
		total = self:_total_armor(),
		max = max_armor,
		no_hint = true
	})
	SoundDevice:set_rtpc("shield_status", 0)
	self:_send_set_armor()
	managers.hud:set_player_health({
		current = self:get_real_health(),
		total = self:_max_health(),
		revives = Application:digest_value(self._revives, false)
	})
	self:_send_set_health()
	self:_set_health_effect()
	self:_damage_screen()
	self:_check_bleed_out()
	self:_call_listeners(damage_info)
	return true
end