task.wait(2)
local CircleState = "Play"
local TS = game:GetService("TweenService")
local function UpdateCircle(State)
	local ProgressCircle = require(game.Players.LocalPlayer.PlayerScripts.LoadingAnims)
	local LoadCircle3 = ProgressCircle.new({BGColor = Color3.fromRGB(9, 9, 9), Position = UDim2.fromScale(0.04, 0.65)})
	LoadCircle3.Color = Color3.new(1, 1, 1)
	LoadCircle3.BGRoundness = 0.1
	LoadCircle3.AnchorPoint = Vector2.new(0.5, 0.5)
	if State == "Play" then
		local TweenInf = TweenInfo.new(0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
		LoadCircle3:Tween(TweenInf, {Color = Color3.fromRGB(64, 131, 255), AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5, 0.5)})
		LoadCircle3:Animate("InfSpin3")
	elseif State == "End" then
		LoadCircle3:Destroy()
	end
end
--[[
local function LoadingCircle()
	local ProgressCircle = require(game.Players.LocalPlayer.PlayerScripts.LoadingAnims)
	local LoadCircle3 = ProgressCircle.new({BGColor = Color3.fromRGB(9, 9, 9), Position = UDim2.fromScale(0.04, 0.65)})
	LoadCircle3.Color = Color3.new(1, 1, 1)
	LoadCircle3.BGRoundness = 0.1
	LoadCircle3.AnchorPoint = Vector2.new(0.5, 0.5)
	LoadCircle3:Animate("InfSpin3")
	local TweenInf = TweenInfo.new(0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	LoadCircle3:Tween(TweenInf, {Color = Color3.fromRGB(64, 131, 255), AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5, 0.5)})
		if CircleState == "End" then
			LoadCircle3:Destroy()
			CircleState = "Play"
		end
end
]]
local function SkeletonLoadingAnimation(Frame)
	for i, v in ipairs(Frame) do
		if v:IsA("Frame") then
			local Items = v:GetDescendants()
			for i, v in ipairs(Items) do
				if v:IsA("TextLabel") or v:IsA("ImageLabel") or v:IsA("TextBox") or v:IsA("TextButton") and not v.Name == "Template" and not v.Name == "Background" then
					print(v.Name)
					task.spawn(function()
						local anim = game:GetService("TweenService"):Create(
							v,
							TweenInfo.new(
								2,
								Enum.EasingStyle.Quad,
								Enum.EasingDirection.InOut,
								0,
								true,
								0
							),
							{
								BackgroundTransparency = 0.7
							}
						)
						anim:Play()
					end)
				end
				if v:IsA("TextButton") then
					task.spawn(function()
						local anim = game:GetService("TweenService"):Create(
							v,
							TweenInfo.new(
								2,
								Enum.EasingStyle.Quad,
								Enum.EasingDirection.InOut,
								0,
								true,
								0
							),
							{
								BackgroundTransparency = 0.7
							}
						)
						anim:Play()
					end)
				end
				if v:IsA("ImageLabel") then
					if not v.Name == "Background" then
						task.spawn(function()
							local anim = game:GetService("TweenService"):Create(
								v,
								TweenInfo.new(
									2,
									Enum.EasingStyle.Quad,
									Enum.EasingDirection.InOut,
									0,
									true,
									0
								),
								{
									ImageTransparency = 0.7
								}
							)
							anim:Play()
						end)
					end
				end
			end
		end
	end
end

local function EndCircle()
	local ProgressCircle = require(game.Players.LocalPlayer.PlayerScripts.LoadingAnims)
	game.Players.LocalPlayer.PlayerGui.CircularProgress.Enabled = false
	CircleState = "End"
end	
if game:GetService("RunService"):IsStudio() then
	script.Parent.LoadingBar:Destroy()
	script.Parent.index.Text = "Couldn't fetch servers."
	script.Parent.pw.Text = "Error 7; This does not work in Studio. Please run it on a client, or a real game server."
	return
end
script.Parent.index:Destroy()
script.Parent.Load:Destroy()
script.Parent.pw:Destroy()
script.Parent.LoadingBar:Destroy()

local Template = script.Parent.MainFrame.Template:Clone()
script.Parent.MainFrame.Template:Destroy()

local function hms(seconds)
	return string.format("%02i:%02i:%02i", seconds/60^2, seconds/60%60, seconds%60)
end

local GetServerIndexRemote = game:GetService("ReplicatedStorage").PSRemotes:WaitForChild("GetServerIndexRemote")
local TeleportToServerRemote = game:GetService("ReplicatedStorage").TPRemote
while true do
	local Servers = GetServerIndexRemote:InvokeServer()
	if Servers == nil then continue end
	local Index = 0
	for i, ServerObj in pairs(Servers) do
		for i, v in ipairs(script.Parent.MainFrame:GetChildren()) do
			if v:IsA("Frame") and not v:GetAttribute("DontDelete") then
				v:Destroy()
			end
		end
		local GuiEntry = Template:Clone()
		GuiEntry:SetAttribute("DontDelete", true)
		GuiEntry.Visible = true
		GuiEntry.Number.Text = i
		GuiEntry.Players.Text = ServerObj[2].Players
		GuiEntry.Uptime.Text = hms(ServerObj[2].Uptime)
		GuiEntry.Position = UDim2.fromScale(0, 0.025*Index)
		GuiEntry.manage.MouseButton1Click:Connect(function()
			--[[
			local ProgressCircle = require(game.Players.LocalPlayer.PlayerScripts.LoadingAnims)
			local LoadCircle3 = ProgressCircle.new({BGColor = Color3.fromRGB(9, 9, 9), Position = UDim2.fromScale(0.04, 0.65)})
			LoadCircle3.Color = Color3.new(1, 1, 1)
			LoadCircle3.BGRoundness = 0.1
			LoadCircle3.AnchorPoint = Vector2.new(0.5, 0.5)
			local TweenInf = TweenInfo.new(0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
			LoadCircle3:Tween(TweenInf, {Color = Color3.fromRGB(64, 131, 255), AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5, 0.5)})
			LoadCircle3:Animate("InfSpin3")
			]]
			script.Parent.Managef.Visible = true
			for i = 1, 5 do
				SkeletonLoadingAnimation(script.Parent.Managef.SkeletonLoading:GetChildren())
				task.wait(4)
			end
			script.Parent.Managef.SkeletonLoading.Visible = false
			local PlayersTable = ServerObj[2].Players
			--	LoadCircle3:Destroy()
			for i, v in pairs(PlayersTable) do
				local Frame = script.Parent.Manage.ScrollingFrame.Template:Clone()
				Frame.Visible = true
				Frame.Name = i
				Frame.Parent = script.Parent.Managef.ScrollingFrame
				Frame.Thumbnail.Image = game.Players:GetUserThumbnailAsync(v.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
				Frame.Username.Text = v.Name
				--
			end
		end)
		if ServerObj[1] == game.JobId then
			GuiEntry.join.BackgroundColor3 = Color3.fromRGB(86, 86, 86)
			GuiEntry.join.Text = "Currently In game"
		else
			GuiEntry.join.MouseButton1Click:Connect(function()
				TeleportToServerRemote:InvokeServer(ServerObj[1])
			end)
		end
		GuiEntry.Parent = script.Parent.MainFrame
		Index += 1
	end
	for i, GuiEntry in ipairs(script.Parent.MainFrame:GetChildren()) do
		if GuiEntry:IsA("Frame") then
			GuiEntry:SetAttribute("DontDelete", false)
		end
	end
	wait(1)
end
