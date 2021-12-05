local _init=EquipmentsTweakData.init
local _hefty={
	bank_manager_key=100,
	lance_part=100,
	boards=100,
	planks=100,
	thermite_paste=100,
	gas=100,
	acid=100,
	caustic_soda=100,
	hydrogen_chloride=100,
	evidence=100,
	}

function EquipmentsTweakData:init()
	_init(self)
	for name, quantity in pairs(_hefty) do
		self.specials[name].quantity=1
		self.specials[name].max_quantity=quantity
		end
	end