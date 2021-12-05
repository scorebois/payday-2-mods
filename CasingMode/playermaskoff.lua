PlayerMaskOff = PlayerMaskOff or class(PlayerStandard)

function PlayerMaskOff:init(unit)
	PlayerMaskOff.super.init(self, unit)

	self._mask_off_attention_settings = {
		"pl_civilian"
	}
end