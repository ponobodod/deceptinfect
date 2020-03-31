ENT.Base = "base_entity"
ENT.Type = "anim"

function ENT:Think(...)
	if (not self._gHaxeInit) then
		self._gHaxeBurrow:Initalize()
	end
	self._gHaxeBurrow:Think(...)
end


function ENT:Initialize(...)
	local ent = deceptinfect_HAXE_EXPORT.di_battery.new(self)
	self._gHaxeBurrow = ent
	self._gHaxeBurrow:Initialize()
	self._gHaxeInit = true
end

function ENT:Draw(...)
	self._gHaxeBurrow:Draw(...)
end

