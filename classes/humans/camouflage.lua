ZPClass.Name = "HumanCamouflageClassName"
ZPClass.Description = "HumanCamouflageClassDescription"
ZPClass.MaxHealth = 50
ZPClass.PModel = "models/combine_xen.mdl"
ZPClass.Speed = 220
ZPClass.RunSpeed = 240
ZPClass.CrouchSpeed = 0.4
ZPClass.Gravity = 1
ZPClass.Breath = 50
ZPClass.AbilityRecharge = 60
function ZPClass:Ability(ply)
	local AuxClass = table.Random(RoundManager:GetAliveZombies()):GetZombieClass()
	ply:SetWalkSpeed(AuxClass.Speed)
	ply:SetRunSpeed(AuxClass.RunSpeed)
	ply:SetCrouchedWalkSpeed(AuxClass.CrouchSpeed)
	ply:SetModel(AuxClass.PModel)
	ply:SetupHands()
	ply:SetAuxGravity(AuxClass.Gravity)
	local TimerName = "Camouflage" .. ply:SteamID64()
	timer.Create(TimerName, 30, 1, function()
		local ZPClass = ply:GetHumanClass()
		ply:SetHealth(ZPClass.MaxHealth)
		ply:SetWalkSpeed(ZPClass.Speed)
		ply:SetRunSpeed(ZPClass.RunSpeed)
		ply:SetCrouchedWalkSpeed(ZPClass.CrouchSpeed)
		ply:SetModel(ZPClass.PModel)
		ply:SetupHands()
		ply:SetAuxGravity(ZPClass.Gravity)
	end)

	local EventName = "ZPResetAbilityEvent" .. ply:SteamID64()
	hook.Add(EventName, TimerName, function()
		ply:SetNextAbilityUse(0)

		timer.Destroy(TimerName)
		hook.Remove(EventName, TimerName)
	end)
end
function ZPClass:CanUseAbility()
	return RoundManager:GetRoundState() == ROUND_PLAYING && RoundManager:CountZombiesAlive() > 0
end

if(ZPClass:ShouldBeEnabled()) then
	ClassManager:AddZPClass("CamouflageHuman", ZPClass, TEAM_HUMANS)
end