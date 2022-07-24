--[[
PreloadingService, DarkPixlz 2022, V1.9. Do not claim as your own!
Info in PreloadingService/DefaultUI/ABOUT
]]

--WARNING: IF YOU DID NOT BUY THIS FROM @DarkPixlz OR THE DEVFORUM, YOU GOT SCAMMED AND THERE IS PROBABLY A VIRUS IN HERE!
--THERE IS NO require() or getfenv 's in here! Press control/command + F, then type require() and getfenv().
--IF THE RESULTS AREN'T COMMENTED, DELETE THIS SCRIPT! GET IT FROM THE DEVFORUM LINK ABOVE. STAY SAFE FROM SCAMS!
local Loader = {}
Loader.Admins = {} --for player control
Loader.Completed = Instance.new("RemoteEvent")
repeat task.wait() until Loader.Completed
local Settings = require(script.Settings)
function Print(msg)
	if Settings.PrintData == true then
		print("[PreloadService]: "..msg)
	end
end
Loader.GameLoaded = false
function Loader.Load(AssetsData, UIType, CustomUI, Code) --TMP: a argument. TODO: Find fix for it so I can remove it.
	if Loader.GameLoaded then Print("Game has already been loaded for user!") return end --Wont be used for now
	local ContentProvider = game:GetService("ContentProvider")
	local text
	local barImg
	--	local NewUI = CustomUI:Clone()
	local Frame
	local Type
	local DefaultUI = false
	local startTime = os.clock()
	if not AssetsData == nil then
	else
		DefaultUI = true
		if AssetsData == "Game" then
			Type = "Game"
			print("hi")
			AssetsData = {
				game:GetService("HttpService"),
				game.Players.LocalPlayer.PlayerGui,
				game:GetService("Workspace"),
				game:GetService("Players"),
				game:GetService("NetworkClient"),
				game:GetService("ReplicatedFirst"),
				game:GetService("ReplicatedStorage"),
				game:GetService("ServerStorage"),
				game:GetService("StarterPack"),
				game:GetService("StarterPlayer"),
				game:GetService("Teams"),
				game:GetService("SoundService"),
				game:GetService("Chat"),
				game:GetService("LocalizationService"),
				game:GetService("Lighting")
			} 
		end
	end
	--	NewUI.Parent = script
	--	NewUI.Name = "PreloadServiceCustomUI"
	if CustomUI == nil then
		if Type == "Game" then
			if not Settings.LightDefaultUI then
				local DefaultUI = script.DefaultUI:Clone()
				DefaultUI.Parent = game.Players.LocalPlayer.PlayerGui
				text = DefaultUI.Game.LoadingText
				barImg = DefaultUI.Game.Bar.Progress
				UIType = "DarkGame"
			else
				local DefaultUI = script.DefaultUI:Clone()
				DefaultUI.Parent = game.Players.LocalPlayer.PlayerGui
				text = DefaultUI.GameLight.LoadingText
				barImg = DefaultUI.Game.Bar.Progress
				UIType = "LightGame"
			end
		elseif UIType == "None" then
			local DefaultUI = script.DefaultUI:Clone()
			DefaultUI.Parent = game.Players.LocalPlayer.PlayerGui
			text = DefaultUI.GameLight.LoadingText
			barImg = DefaultUI.Game.Bar.Progress
			UIType = "None"
		else
			if not Settings.LightDefaultUI then
				local DefaultUI = script.DefaultUI:Clone()
				DefaultUI.Parent = game.Players.LocalPlayer.PlayerGui
				text = DefaultUI.Other.LoadingText
				barImg = DefaultUI.Other.Bar.Progress
				UIType = "DarkOther"
			else
				local DefaultUI = script.DefaultUI:Clone()
				DefaultUI.Parent = game.Players.LocalPlayer.PlayerGui
				text = DefaultUI.OtherLight.LoadingText
				barImg = DefaultUI.OtherLight.Bar.Progress
				UIType = "LightOther"
			end
		end
	else
		text = CustomUI.LoadingText
		barImg = CustomUI.Bar.Progress
	end
	if UIType == "None" then
		text.Parent.Visible = false
	end
	text.Parent.Visible = true
	text.Text = "Loading.. ["..#AssetsData.."]"
	if not Settings.UseTweens and not CustomUI then
		text.Parent.Bar.LocalScript:Destroy()
	end
	task.wait(Settings.StartDelay)
	local succ, err = pcall(function()
		if CustomUI == nil then
			text.Parent.Bar.LocalScript:Destroy()
			task.wait(0.1)
			barImg:TweenSizeAndPosition(UDim2.new(0,0,1,0), UDim2.new(0,0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 1, true)
			task.wait(1.5)
		end
		for i = 1, #AssetsData do
			local startAssetTime = os.clock()
			local Asset = AssetsData[i]
			local Name = Asset.Name
			text.Text = "Loading "..Name.." [".. i .. " / "..#AssetsData.."]"
			if Asset.Name == "HttpService" then
				text.Text = "Pinging HttpService.."
			end
			if not Asset:IsA("ModuleScript") then
				ContentProvider:PreloadAsync({Asset})
				local TimeLoaded = os.clock() - startAssetTime
				game.ReplicatedStorage.PSRemotes.ServerCompleted:FireServer(TimeLoaded, Asset.ClassName, Asset.Name,"Other", Asset)
				task.wait(Settings.InBetweenAssetsDelay)
				local Progress = i / #AssetsData
				if Settings.UseTweens then
					barImg:TweenSize(UDim2.new(Progress, 0, 1, 0), Enum.EasingDirection.In, Enum.EasingStyle.Sine, .5, true)
				else
					barImg.Size = UDim2.new(Progress, 0, 1, 0)
				end
				task.wait()
			else --Is a module
				ContentProvider:PreloadAsync({Asset})
				require(Asset)
				local TimeLoaded = os.clock() - startAssetTime
				game.ReplicatedStorage.PSRemotes.ServerCompleted:FireServer(TimeLoaded, Asset.ClassName, Asset.Name, "Module", Asset)
				task.wait(Settings.InBetweenAssetsDelay)
				local Progress = i / #AssetsData
				if Settings.UseTweens then
					barImg:TweenSize(UDim2.new(Progress, 0, 1, 0), Enum.EasingDirection.In, Enum.EasingStyle.Sine, .5, true)
				else
					barImg.Size = UDim2.new(Progress, 0, 1, 0)
				end
				task.wait()
			end
		end
	end)
	if not succ then
		warn("[PreloadService]: Could not preload an item! Error: "..err) 
		text.Text = "Failed to load. Error: "..err..". Please rejoin, and notify the game owner or developer."
		local End = {Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.fromRGB(255, 69, 72)}
		local Info = TweenInfo.new(5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 2)
		local Tween = game:GetService("TweenService"):Create(barImg, Info, End)
		Tween:Play()
	else
		text.Text = "Finished!"
		local ItemsToTween = {}
		local TextToTween = {}
		local DefautUI = game.Players.LocalPlayer.PlayerGui.DefaultUI
		local endTime = os.clock() - startTime
		Print("Successfully loaded in "..math.round(endTime).." seconds!")
		if DefaultUI then
			if Settings.AutoCloseUI then
				if not Settings.UseTweens then
					game.Players.LocalPlayer.PlayerGui.DefaultUI:Destroy()
				else
					if UIType == "DarkGame" then
						ItemsToTween = {
							DefautUI.Game,
							DefautUI.Game.Bar,
							DefautUI.Game.Bar.Progress,
						}
						TextToTween = {
							DefautUI.Game.LoadingText,
							DefautUI.Game.MainLabel,
							DefautUI.Game.welcomeMessage,
						}
					elseif UIType == "LightGame" then
						ItemsToTween = {
							DefautUI.GameLight,
							DefautUI.GameLight.Bar,
							DefautUI.GameLight.Bar.Progress
						}
						TextToTween = {
							DefautUI.GameLight.LoadingText,
							DefautUI.GameLight.MainLabel,
							DefautUI.GameLight.welcomeMessage,
						}
					end
					if ItemsToTween ~= nil then
						for i = 1, 100 do
							task.wait(0.001)
							for i, asset in ipairs(ItemsToTween) do
								asset.BackgroundTransparency += 0.01
							end
							for i, asset in ipairs(TextToTween) do
								asset.BackgroundTransparency += 0.01
								asset.TextTransparency += 0.01
							end
						end
					end
					if UIType == "DarkOther" or "LightOther" then
						DefautUI.Other:TweenPosition(UDim2.new(0.328, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .5, true)
						DefautUI.OtherLight:TweenPosition(UDim2.new(0.328, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .5, true)
					end
				end
			end
			DefautUI:Destroy()
		end
		local succ1, err2 = pcall(function() Loader.Completed:FireClient(game.Players.LocalPlayer, endTime, Code) Loader.Completed:FireServer(endTime) end)
		if not succ1 then Print(err2) return else end

	end
end

function Loader.BindFrame(Player, Frame)
	Print("Binding Frame...")
	local FindFrame = Player.PlayerGui:FindFirstDecendant(Frame.Name)
	if not FindFrame then
		Print(' Could not bind frame. Error: Frame does not exist! ')
		return 
	end
	Frame:GetPropertyChangedSignal("Visible"):Connect(function()
		Loader.Load(Frame:GetDecendants(), "None", nil)
	end)
end


function Loader.Print()
	warn("[PreloadService]: Print is an internal function and cannot be used otherwise.")
end

function Loader.CheckVersion()
	--[[
	local marketplace = game:GetService("MarketplaceService")

	local success, result = pcall(function()
		return marketplace:GetProductInfo(8788148542)
	end)

	if success then
		if result then
			if result.Description:match("1.1.1") then
				Print("Up to date! Version: 1.1.1")
			else
				warn("[ProloadService]: Out of date or MarketplaceService error. Please update your module by reinstalling it!")
				if Settings.ShutdownIfOutofDate then script:Destroy() end
			end
		end
	end
	]]
	warn("[PreloadService] ⚠️WARNING: CheckVersion is depercated and only exists for legacy code! You can check from the panel now. Please remove this from your code.")
end

function Loader.FireModule(Module)
	Loader.Load({Module}, "None", nil, "PS_INTERNAL_MODULE")
	Loader.Completed.OnClientEvent:Connect(function(Time,Key)
		if Key == "PS_INTERNAL_MODULE" then
			--Module is loaded
			Module.Fire()
		end
	end)
end

return Loader
