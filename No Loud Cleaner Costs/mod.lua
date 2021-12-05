local civilian_killed_original = MoneyManager.civilian_killed
function MoneyManager:civilian_killed(...)
	if not managers.groupai:state():whisper_mode() then
		return
	end
	return civilian_killed_original(self, ...)
end