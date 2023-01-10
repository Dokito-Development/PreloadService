task.wait(2)
if game:GetService("RunService"):IsStudio() then
	return
end
local Servers = {}
local MemoryStoreService = game:GetService("MemoryStoreService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local ServerIndexMap = MemoryStoreService:GetSortedMap("ServerIndex")
local PlayersMAP = MemoryStoreService:GetSortedMap("AllPlayersGameWide")
local ServerKey = tostring(game.JobId)

local Admins = require(script.Parent.Admins).Admins


local kick = game:GetService("DataStoreService"):GetDataStore("KickData")
game.Players.PlayerAdded:Connect(function(plr)
	while true do
		task.wait(15)
		if kick:GetAsync(plr.UserId)  then
			if kick:GetAsync(plr.UserId) == 1 then
				plr:Kick("[PreloadService]\n Kicked from the game by an admin,.")
			end
		end
	end
end)

function GetAllServers(map)
	local ServerItems = {}
	local StartFrom = nil
	while true do
		local Items = map:GetRangeAsync(Enum.SortDirection.Ascending, 100, StartFrom)
		local succ, err = pcall(function()
			for _, Item in ipairs(Items) do
				table.insert(ServerItems, {Item.key, HttpService:JSONDecode(Item.value)})
			end
		end)
		if not succ then warn(err) Servers =  GetAllServers(ServerIndexMap)end
		if #Items < 100 then
			break
		end
		StartFrom = Items[#Items].key
		wait(3)
	end
	return ServerItems
end


function FlushServers(map)
	local StartFrom = nil
	while true do
		local Items = map:GetRangeAsync(Enum.SortDirection.Ascending, 100, StartFrom)
		for _, Item in ipairs(Items) do
			map:RemoveAsync(Item.key)
		end
		if #Items < 100 then
			break
		end
		StartFrom = Items[#Items].key
		wait(3)
	end
end


function UploadToIndex(map)
	local Data = {
		["Players"] = #game.Players:GetPlayers(),
		["Uptime"] = math.round(RunService.Stepped:Wait()),
		["InGamePlayers"] = game.Players:GetPlayers()
	}
	map:SetAsync(ServerKey, HttpService:JSONEncode(Data), 30)
end


game.Players.PlayerAdded:Connect(function(Player)
	UploadToIndex(ServerIndexMap)
	if Admins[Player.UserId] then
		--[[ coming soon in button form
		Player.Chatted:Connect(function(msg)
			if msg:lower() == "!flush" then
				print("Flushing Server Index")
				FlushServers(ServerIndexMap)
				return
			end
			if msg:lower() == "!upload" then
				print("Uploading to Server Index")
				UploadToIndex(ServerIndexMap)
				return
			end
		end)
		]]
	end
end)
game.Players.PlayerRemoving:Connect(function()
	UploadToIndex(ServerIndexMap)
end)


game:BindToClose(function()
	ServerIndexMap:RemoveAsync(ServerKey)
end)

local GetServerIndexRemote = game.ReplicatedStorage.PSRemotes.GetServerIndexRemote
GetServerIndexRemote.OnServerInvoke = function(Player)
	return Servers
end
local TeleportToServerRemote =game.ReplicatedStorage.TPRemote
TeleportToServerRemote.OnServerInvoke = function(Player, JobId)
	if JobId == nil then return end
	if type(JobId) ~= "string" then return end
	for Index, ServerObj in pairs(Servers) do
		if ServerObj[1] == JobId then
			TeleportService:TeleportToPlaceInstance(game.PlaceId, JobId, Player)
			break
		end
	end
end
TeleportToServerRemote.Parent = ReplicatedStorage


if not game:GetService("RunService"):IsStudio() then
while true do
	if not game:GetService("RunService"):IsStudio() then
		UploadToIndex(ServerIndexMap)
		Servers = GetAllServers(ServerIndexMap)
		local AdminIds = require(script.Parent.Admins).Admins
		for i, v in ipairs(game.Players:GetPlayers()) do
			if not table.find(AdminIds,v.UserId) and v.PlayerGui:FindFirstChild("PreloadServiceAdminPanel") then
				v:Kick("PreloadServie: Exploits detected. You may rejoin, or the developer can configure the punishment.")
			end
		end
		task.wait(10)
		end
	end
end


