--[[
PRELOADSERVICE V2
The following is all essential to providing the core functions, and exploit protection.
I advise you do not modify any code, but I cant stop you.
IF YOU MODIFY CODE I WILL NOT OFFER SUPPORT
]]
local CurrentVers = "2.3"
local adminIDs = require(script.Admins).Admins
local players = game:GetService("Players")
local moduleNotRequire = script.PreloadService
moduleNotRequire.Parent = game.ReplicatedStorage
local LoadedModules = {}
local Remotes = Instance.new("Folder")
Remotes.Name = "PSRemotes"
Remotes.Parent = game.ReplicatedStorage
local NewPlayerClient = Instance.new("RemoteEvent", Remotes)
NewPlayerClient.Name = "NewPlayerClient"
local GivenAdmin = Instance.new("RemoteEvent")
local MPS = game:GetService("MarketplaceService")
local PlrCount = 0 
local SpecialEvent = Instance.new("RemoteEvent") --Only for the special parameters
SpecialEvent.Name = "ServerCompleted"
SpecialEvent.Parent = Remotes
local e1 = Instance.new("RemoteFunction")  
e1.Parent = Remotes
e1.Name = "GetServerIndexRemote"
local e2 = Instance.new("RemoteFunction")
e2.Parent = game.ReplicatedStorage
e2.Name = "TPRemote"
local e3 = Instance.new("RemoteEvent")
e3.Parent = Remotes
e3.Name = "CheckForUpdates"
local InGameAdmins = {}
local Settings = require(game.ReplicatedStorage.PreloadService.Settings)
local PS = require(game.ReplicatedStorage.PreloadService)
local CompletedTimes = {}
local Decimals = 2
local ServerLifetime = 0
local function GetSetting(Setting)
	local SettingModule = require(game.ReplicatedStorage.PreloadService.Settings)
	return SettingModule[Setting]
end
local function Format(Int)
	return string.format("%02i", Int)
end
local function Average(Table)
	local number = 0
	for _, value in pairs(Table) do
		number += value
	end
	return number / #Table
end
local kick = game:GetService("DataStoreService"):GetDataStore("KickData")
local KickRem = Instance.new("RemoteEvent", Remotes)
KickRem.Name = "KickPlr"

KickRem.OnServerEvent:Connect(function(player,plrkicked) 
	for i, v in ipairs(InGameAdmins) do
		if player.UserId == v.UserId then
			kick:SetAsync(plrkicked,1)
			task.wait(15)
			kick:SetAsync(plrkicked,0)
		end
	end
end)
local function n(admin, bodytext, headingtext, image, dur, t)
	local Placeholder  = Instance.new("Frame")
	Placeholder.Parent = admin.PlayerGui.PreloadServiceAdminPanel.Notifications
	Placeholder.BackgroundTransparency = 1
	Placeholder.Size = UDim2.new(0.996,0,0.096,0)
	local notif = admin.PlayerGui.PreloadServiceAdminPanel.Notifications.Template:Clone()
	notif.Position = UDim2.new(0.4,0,0.904,0)
	notif.Visible = true
	notif.Size = UDim2.new(0.996,0,0.096,0)
	notif.Parent = admin.PlayerGui.PreloadServiceAdminPanel.NotificationsTest
	notif.Body.Text = bodytext
	notif.Header.Title.Text = headingtext
	notif.Header.ImageL.Image = image                 
	local NewSound  = Instance.new("Sound")
	NewSound.Parent = notif
	if not t then
		NewSound.SoundId = "rbxassetid://9770089602"
		NewSound:Play()		
	else
		NewSound.SoundId = "rbxassetid://9770087788"
		NewSound:Play()
	end
	local TS = game:GetService("TweenService")
	local NotifTween = TS:Create(
		notif,
		TweenInfo.new(
			0.4,
			Enum.EasingStyle.Quart,
			Enum.EasingDirection.In,
			0,
			false,
			0
		),
		{
			Position = UDim2.new(-0.02,0,0.904,0)
		}
	)
	NotifTween:Play()
	NotifTween.Completed:Wait()
	Placeholder:Destroy()
	notif.Parent = admin.PlayerGui.PreloadServiceAdminPanel.Notifications
	task.wait(dur)
	local Placeholder2  = Instance.new("Frame")
	Placeholder2.Parent = admin.PlayerGui.PreloadServiceAdminPanel.Notifications
	Placeholder2.BackgroundTransparency = 1
	Placeholder2.Size = UDim2.new(0.996,0,0.096,0)
	notif.Parent = admin.PlayerGui.PreloadServiceAdminPanel.NotificationsTest
	local NotifTween2 = TS:Create(
		notif,
		TweenInfo.new(
			0.5,
			Enum.EasingStyle.Quart,
			Enum.EasingDirection.In,
			0,
			false,
			0
		),
		{
			Position = UDim2.new(1.8,0,0.904,0)
		}
	)
	NotifTween2:Play()
	NotifTween2.Completed:Wait()
	notif:Destroy()
	Placeholder2:Destroy()
end

function GetShortNumer(Number)
	return math.floor(((Number < 1 and Number) or math.floor(Number) / 10 ^ (math.log10(Number) - math.log10(Number) % 3)) * 10 ^ (Decimals or 3)) / 10 ^ (Decimals or 3)..(({"k", "M", "B", "T", "Qa", "Qn", "Sx", "Sp", "Oc", "N"})[math.floor(math.log10(Number) / 3)] or "")
end
local function NewNotification(admin, bodytext, headingtext, image, dur, t)
	task.spawn(n,admin,bodytext,headingtext,image,dur, t)
end


local function GetTimeWithSeconds(Seconds)
	local Minutes = (Seconds - Seconds%60)/60;
	Seconds = Seconds - Minutes*60;

	local Hours = (Minutes - Minutes%60)/60;
	Minutes = Minutes - Hours*60;

	return Format(Hours)..":"..Format(Minutes)..":"..Format(Seconds);
end
local CurrentlyExisting = 0
--Thanks to @334901766 for helping out a bit
local function MakeHomeHistoryBox(Admin,PFP,Username,InstanceName,InstanceType,Time)
	CurrentlyExisting = #Admin.PlayerGui.PreloadServiceAdminPanel.Main.AHome.HistoryWidget:GetChildren()
	if CurrentlyExisting >= 50 then
		for i = 1, (CurrentlyExisting - 50) do
			Admin.PlayerGui.PreloadServiceAdminPanel.Main.AHome.HistoryWidget:FindFirstChildWhichIsA("Frame"):Destroy()
		end
	end
	CurrentlyExisting = #Admin.PlayerGui.PreloadServiceAdminPanel.Main.AHome.HistoryWidget:GetChildren()

	local NewCard = Admin.PlayerGui.PreloadServiceAdminPanel.Main.AHome.Template:Clone()
	NewCard.Parent =Admin.PlayerGui.PreloadServiceAdminPanel.Main.AHome.HistoryWidget
	NewCard.Visible = true
	NewCard.Name = CurrentlyExisting
	NewCard.PlayerImage.Image = PFP
	NewCard.Username.Text = "@"..Username
	NewCard.Time.Text = Time
	NewCard.Type.Text = InstanceName
end

local function MakeHistory(Admin,PFP,Username,InstanceName,InstanceType,Time)
	CurrentlyExisting = #Admin.PlayerGui.PreloadServiceAdminPanel.Main.History.MainFrame:GetChildren()
	if CurrentlyExisting >= GetSetting("MaxHistoryItems") then
		for i = 1, (CurrentlyExisting - GetSetting("MaxHistoryItems")) do
			Admin.PlayerGui.PreloadServiceAdminPanel.Main.History.MainFrame:FindFirstChildWhichIsA("Frame"):Destroy()
		end
	end
	CurrentlyExisting = #Admin.PlayerGui.PreloadServiceAdminPanel.Main.History.MainFrame:GetChildren()

	local NewCard = Admin.PlayerGui.PreloadServiceAdminPanel.Main.History.Template:Clone()
	NewCard.Parent =Admin.PlayerGui.PreloadServiceAdminPanel.Main.History.MainFrame
	NewCard.Visible = true
	NewCard.Name = CurrentlyExisting
	NewCard.PlayerImage.Image = PFP
	NewCard.Username.Text = "@"..Username
	NewCard.Time.Text = Time
	NewCard.Type.Text = InstanceName
end
local function MakeModuleHistoryCard(Admin,PFP,Username,InstanceName,InstanceType,Time)
	CurrentlyExisting = #Admin.PlayerGui.PreloadServiceAdminPanel.Main.AHome.HistoryWidget:GetChildren()
	if CurrentlyExisting >= 50 then
		for i = 1, (CurrentlyExisting - 50) do
			Admin.PlayerGui.PreloadServiceAdminPanel.Main.AHome.HistoryWidget:FindFirstChildWhichIsA("Frame"):Destroy()
		end
	end
	CurrentlyExisting = #Admin.PlayerGui.PreloadServiceAdminPanel.Main.AHome.HistoryWidget:GetChildren()

	local NewCard = Admin.PlayerGui.PreloadServiceAdminPanel.Main.AHome.Template:Clone()
	NewCard.Parent =Admin.PlayerGui.PreloadServiceAdminPanel.Main.AHome.HistoryWidget
	NewCard.Visible = true
	NewCard.Name = CurrentlyExisting
	NewCard.PlayerImage.Image = PFP
	NewCard.Username.Text = "@"..Username
	NewCard.Time.Text = Time
	NewCard.Type.Text = InstanceName
end


local function VersionCheck(plr)
	task.wait(2)
	if not table.find(InGameAdmins,plr) then
		warn("ERROR: Unexpected call of CheckForUpdates")
		plr:Kick("\n [PreloadService]: \n Unexpected Error:\n \n Exploits or non admin tried to fire CheckForUpdates. \n Developers, if this is in your code, then please do not fire it, that will result in players being kicked unexpectedly.\n Please only fire it from the Admin Panel, the remote is only for server communication. \n \n Error code 0x83jd29, end of error")
		while task.wait(.5) do
			warn("ERROR: Unexpected call of CheckForUpdates")
		end
	end
	local VersModule = require(8788148542)
	local Frame = plr.PlayerGui.PreloadServiceAdminPanel.Main.Menu.Main.BUpdate
	Frame.Parent.AInfo.vers.Text = CurrentVers.." by DarkPixlz, 2022".."(latest avail: "..VersModule.Version..", released "..VersModule.ReleaseDate..". Licensed under TBD."
	if VersModule.Version ~= CurrentVers then
		warn("[PreloadService]: Out of date! Please update your module by closing this server.")
		Frame.Value.Value = tostring(math.random(1,100000000))
		NewNotification(plr, "Your module is out of date. Please update your module by closing the servers, then replace it in Studio.", "Version check complete", "rbxassetid://9894144899", 10)
	end
end

players.PlayerAdded:Connect(function(plr)
	if table.find(adminIDs, plr.UserId) then
		--		print(players:GetNameFromUserIdAsync(game.CreatorId).." is a furry")
		local newPanel = script.PreloadServiceAdminPanel:Clone() --To avoid exploits, this all happens on the server ;)
		newPanel.Parent = plr.PlayerGui

		if game:GetService("RunService"):IsStudio() then
			NewNotification(plr,"Sorry, but PreloadService Admin does not work in Studio. Pages do not operate and display data.","Error!","rbxassetid://9894144899",15, true)
		else
			task.spawn(NewNotification,plr,"Please wait, loading Admin Panel","Loading PreloadService Admin Panel v"..CurrentVers,"rbxassetid://9894144899", 8)
		end

		for i, asset in pairs(newPanel:GetDescendants()) do
			local succ, err = pcall(function()
				game:GetService("ContentProvider"):PreloadAsync({asset})
			end)
			if not succ then
				warn(asset.Name.." could not load. Error: "..err)
			end
		end
		table.insert(InGameAdmins, plr)
		local Frame = plr.PlayerGui.PreloadServiceAdminPanel.Main.Menu.Main.BUpdate
		Frame.Parent.AInfo.vers.Text = CurrentVers.." by DarkPixlz, 2022. Licensed under TBD."
		NewNotification(plr,"PreloadSerevice Admin Panel v"..CurrentVers.." loaded! Press F2 to enter the panel.","Welcome!","rbxassetid://10012255725",15)

	end
	game:GetService("Players").PlayerRemoving:Connect(function()

	end)
	local newPlrCount = #players:GetPlayers()
	PlrCount += newPlrCount
	NewPlayerClient:FireAllClients(PlrCount)
--[[
	local ver = require(8788148542).Version
	if ver~=2.0 then
		warn("outofdate_err")
	end 
	]]
end)
players.PlayerRemoving:Connect(function(plr)
	if table.find(InGameAdmins, plr) then
		table.remove(InGameAdmins, table.find(InGameAdmins, plr))
	end
end)
SpecialEvent.OnServerEvent:Connect(function(PlayerLoaded, Time, ItemClass, ItemName, ModOrRegular, item)
	table.insert(CompletedTimes,Time)
	ServerLifetime += 1
	for i, v in ipairs(InGameAdmins) do
		MakeHomeHistoryBox(
			v,
			players:GetUserThumbnailAsync(PlayerLoaded.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420),
			PlayerLoaded.Name,
			ItemName,
			ItemClass,
			GetTimeWithSeconds(Time)
		)
		local Frame = v.PlayerGui.PreloadServiceAdminPanel.Main.History.MainFrame
		if not Frame then
			warn("[PreloadService ERROR]: Could not find Summary of the main panel! \n Roblox error tree is below, it could be because you renamed the panel, or multiple UI's names 'panel' exist.")
		end
		if ItemClass ~= "ModuleScript" then
			MakeHistory(
				v,
				players:GetUserThumbnailAsync(PlayerLoaded.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420),
				PlayerLoaded.Name,
				ItemName,
				ItemClass,
				GetTimeWithSeconds(Time)
			)
			local Home = Frame.Parent.Parent.AHome
			Home.total.Text = GetShortNumer(#CompletedTimes).." total assets loaded"
			Home.avg.Text = GetTimeWithSeconds(Average(CompletedTimes)).." average loading time, or lower"
			Home.server.Text = GetShortNumer(ServerLifetime).." assets loaded in server lifetime"
		else
			table.insert(LoadedModules, item)
			local new = Frame.Template:Clone()
			new.Visible = true
			new.Parent = Frame
			new.ItemName.Text = "Loaded "..ItemName
			new.Type.Text = ItemClass
			if not (GetTimeWithSeconds(Time) == "00:00:00") then
				new.Time.Text = GetTimeWithSeconds(Time)
			else
				new.Time.Text = "🎉 Below 0"
			end
			new.Username.Text = PlayerLoaded.DisplayName.."(@"..PlayerLoaded.Name..")"
			task.wait(Settings.renderTime)
			new.thumbnail.Image = players:GetUserThumbnailAsync(PlayerLoaded.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
			--History
			local new = Frame.Parent.Parent.Modules.MainFrame.Template:Clone()
			new.Visible = true
			new.Parent =  Frame.Parent.Parent.Modules.MainFrame
			new.ItemName.Text = "loaded "..ItemName
			new.Type.Text = ItemClass
			new.Time.Text = GetTimeWithSeconds(Time).." or lower"
			new.Username.Text = PlayerLoaded.DisplayName.."(@"..PlayerLoaded.Name..")"
			new.thumbnail.Image = players:GetUserThumbnailAsync(PlayerLoaded.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
			local Home = Frame.Parent.Parent.AHome
			local ModulesFrame = Frame.Parent.Parent.Modules
			Home.total.Text = GetShortNumer(#CompletedTimes).." total assets loaded"
			--			Home.server.Text = GetShortNumer(ServerLifetime).." assets loaded in server lifetime"
			--			print(Home.server.Text..", "..ServerLifetime)
			if not (GetTimeWithSeconds(Time) == "00:00:00") then
				Home.avg.Text = GetTimeWithSeconds(Average(CompletedTimes)).." Average Loading Time"
			else
				Home.avg.Text = "🎉 Average is 0 or lower!"
			end

			if not(#LoadedModules == 1) then
				Home.modules.Text = GetShortNumer(#LoadedModules).." loaded modules"
			else
				Home.modules.Text = "1 loaded module"
			end
		end
	end
end)

e3.OnServerEvent:Connect(function(plr)
	task.wait(2)
	--[[
	if not table.find(InGameAdmins,plr) then
		warn("ERROR: Unexpected call of CheckForUpdates")
		plr:Kick("\n [PreloadService]: \n Unexpected Error:\n \n Exploits or non admin tried to fire CheckForUpdates. \n Developers, if this is in your code, then please do not fire it, that will result in players being kicked unexpectedly.\n Please only fire it from the Admin Panel, the remote is only for server communication. \n \n Error code 0x83jd29, end of error")
		while task.wait(.5) do
			warn("ERROR: Unexpected call of CheckForUpdates")
		end
	end
	]]
	local VersModule = require(8788148542)
	VersModule.Parent = script
	local Frame = plr.PlayerGui.PreloadServiceAdminPanel.Main.Menu.Main.BUpdate
	Frame.Parent.AInfo.vers.Text = CurrentVers.." by DarkPixlz, 2022".."(latest avail: "..VersModule.Version..", released "..VersModule.ReleaseDate..". Licensed under TBD."
	Frame.Value.Value = tostring(math.random(1,100000000))
	Frame.Parent.CLogs.log.Text = VersModule.ReleaseNotes
	Frame.Parent.CLogs.title.Text = "Update Logs (v"..VersModule.Version..")"
	if VersModule.Version ~= CurrentVers then
		warn("[PreloadService]: Out of date! Please update your module by closing this server.")
		Frame.Value.Value = tostring(math.random(1,100000000))
		NewNotification(plr, "Your module is out of date. Please update your module by closing the servers, then replace it in Studio.", "Version check complete", "rbxassetid://9894144899", 25)
	else
		NewNotification(plr, "Your module is up to date! Current: "..CurrentVers, "Version check complete", "rbxassetid://9894144899", 25)
	end
end)
