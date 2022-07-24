--DARKPIXLZ 2022

--PreloadService


--DESC:
--[[

- Handles Navigation
- Handles Animation
- Handles SFX
- Handles Panel Open
- Handles some remotes



There are some ~~pretty weird~~ things commented, ignore them
]]
local function IsAcrylicUsed()
	return not require(game.ReplicatedStorage.PreloadService.Settings).UseArcylic
end
local Theme = require(script.Parent.Themes:FindFirstChildWhichIsA("ModuleScript"))
local last = "AHome"
game.ReplicatedStorage.PSRemotes.NewPlayerClient.OnClientEvent:Connect(function(a)
	print(a)
	script.Parent.Main.AHome.Joined.Text = a.." Players in Server Lifetime"
	script.Parent.Main.AHome.RightNow.Text = #game.Players:GetPlayers().." in game right now"
end)
local function PlaySFX()
	script.Sound:Play()
end
script.Parent.Main.Header.ScaleType = Enum.ScaleType.Crop
local UIS = game:GetService("UserInputService")
--//NAVIGATION\\--

local mainNav = script.Parent.Main.bottom
local expandedNav = script.Parent.Main.expanded
local menuDB = false
local last2
local function NewNotification(admin, bodytext, headingtext, image, dur)
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
	NewSound.SoundId = "rbxassetid://9770089602"
	NewSound:Play()
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

for i, v in ipairs(mainNav.buttons:GetChildren()) do
	local frame = string.sub(v.Name, 2,100)
	v.TextButton.MouseButton1Click:Connect(function()
		if v.Name == "AMinimize" then return end
		if script.Parent.Main:FindFirstChild(frame) then
			last2 = v.Name
			script.Parent.Main.Animation.Position = UDim2.new(0,0,0,0) --Fixes bug present in 2.0.0, atleast it should..
			script.Parent.Main.Animation:TweenSize(UDim2.new(1,0,1,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
			PlaySFX()
			script.Parent.Main[tostring(last)].Visible = false
			last = frame
			task.wait(require(game.ReplicatedStorage.PreloadService.Settings).PanelLoadingTime)
			script.Parent.Main[frame].Visible = true
			v.BackgroundTransparency = 0
			v.BackgroundColor3 = Theme.AccentColor
			script.Parent.Main.bottom.buttons[last2].BackgroundTransparency = 1
			task.wait(0.2)
			script.Parent.Main.Animation:TweenSizeAndPosition(UDim2.new(0,0,1,0), UDim2.new(1,0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
			task.wait(.2)
			script.Parent.Main.Animation.Position = UDim2.new(0,0,0,0)
	--		NewNotification(game.Players.LocalPlayer, frame.." has been opened, this is to test the new notification system ;)", "Test notification", "rbxassetid://9482016562", 5)
		else  --Doesn't exist
			warn("[PreloadService]: Page not found! If you added a button please make sure that a page with the same name, but without the first character exists!")
			script.Parent.Main[tostring(last)].Visible = false	
			last = "Other"
			script.Parent.Main.Other.Visible = true
		end
		--		print('"uwu" 🤓')
	end)
end
--	print('"owo" 🤓')

-- OPENING/CLOSING ANIMATION BY 6Marchy4
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local neon = require(script.Parent.ButtonAnims:WaitForChild("neon"))
local IsOpen = true
local function Open()
	script.Parent:SetAttribute("IsVisible", true)
	if IsAcrylicUsed() then
		neon:BindFrame(script.Parent.Main.Blur, {
			Transparency = 0.98;
			BrickColor = BrickColor.new("Institutional white");
		})
	end
	local Main = script:FindFirstAncestorOfClass("ScreenGui"):FindFirstChildOfClass("Frame")
	Main.Visible = true
	TS:Create(Main, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(Main.Position.X.Scale, Main.Position.Y.Scale - 0.05);
		BackgroundTransparency = 0;
	}):Play()
	for _, Descendant in pairs(Main:GetDescendants()) do
		if Descendant:IsA("TextLabel") then
			TS:Create(Descendant, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				TextTransparency = 0
			}):Play()
		end
		if Descendant:IsA("ImageLabel") then
			TS:Create(Descendant, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				ImageTransparency = 0
			}):Play()
		end
		if Descendant:IsA("TextButton") and Descendant:GetAttribute("IsVisible") then
			TS:Create(Descendant, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				TextTransparency = 0;
				BackgroundTransparency = 0
			}):Play()
		end
		if Descendant:IsA("Frame") and not Descendant:GetAttribute("ExcludeTransparent") then
			TS:Create(Descendant, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0
			}):Play()
		end
	end
end
local function Close()
	script.Parent:SetAttribute("IsVisible", false)
	if IsAcrylicUsed() then
		neon:UnbindFrame(script.Parent.Main.Blur)
	end
	local Main = script:FindFirstAncestorOfClass("ScreenGui"):FindFirstChildOfClass("Frame")
	TS:Create(Main, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(Main.Position.X.Scale, Main.Position.Y.Scale + 0.05);
		Transparency = 1;
	}):Play()
	for _, Descendant in pairs(Main:GetDescendants()) do
		if Descendant:IsA("ImageLabel") then
			TS:Create(Descendant, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				ImageTransparency = 1
			}):Play()
		elseif Descendant:IsA("GuiObject") then
			TS:Create(Descendant, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Transparency = 1
			}):Play()
		end
	end
end
Close()
task.wait(.1)
script.Parent.Main.Visible = false


local lad = UIS:IsKeyDown(Enum.KeyCode.LeftAlt)
local pd = UIS:IsKeyDown(Enum.KeyCode.P)
game:GetService("UserInputService").InputBegan:Connect(function(key, typing)
	if typing then 
		return
	end
	lad = UIS:IsKeyDown(Enum.KeyCode.LeftControl)
	if key.KeyCode == Enum.KeyCode.F2 --[[and lad or key.KeyCode == Enum.KeyCode.P and UIS:IsKeyDown(Enum.KeyCode.F1)]] then
		if menuDB == false then
			Open()
			PlaySFX()
			menuDB = true
		else
			Close()
			PlaySFX()
			menuDB = false
			task.wait(.1)
			script.Parent.Main.Visible = false
		end
	else return end
end)

script.Parent.Main.Header.Minimize.MouseButton1Click:Connect(function()
	Close()
	PlaySFX()
	menuDB = false
	task.wait(.1)
	script.Parent.Main.Visible = false
end)

script.Parent.Main.Menu.Main.BUpdate.Check.MouseButton1Click:Connect(function()
	local tl = script.Parent.Main.Menu.Main.BUpdate.Text
	tl.Text = "Checking..."
	task.wait(0.4)
	tl.Text = "Waiting for server response.."
	game.ReplicatedStorage.PSRemotes.CheckForUpdates:FireServer()
	tl.Parent.Value.Changed:Connect(function()
		tl.Text = "Completed."
	end)
	task.wait(5)
	tl.Text = "Check for Updates"
end)
