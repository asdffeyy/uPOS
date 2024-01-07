local screnpart = script.Parent.Screen.Screen
local screen = screnpart.awareOS
local user = nil
local total = 0
local gconfig = require(script.Parent.Parent.Parent.Configuration.MasterConfig)
local swiperdeb = false
local loggedoffscreen = screen.LoggedOff
local user = "anger"
local tillsettings = require(script.Parent.TillSettings).settings
local cafepositems = {}
local main = screen.Main
local cstrdispting = script.Parent.CustomerScreen.Screen.awareOS.Main
local items = {}
local itemamount = 0
local scandeb = false
local config = require(script.Parent.Parent.Parent.Configuration.MasterConfig)
local folder
local api = script.Parent.AwareNetwork
local deals = require(script.Parent.Parent.Parent.Configuration.Deals).deals
local kitchen = tillsettings.HoldItems
local tblnum
if tillsettings.TillPower == "NoPower" then
	script:Destroy()
end
if tillsettings.HoldItems and not game.ReplicatedStorage:FindFirstChild("uPOS_CafePOS") then
	folder = Instance.new("Folder")
	folder.Parent = game.ReplicatedStorage
	folder.Name = "uPOS_CafePOS"
end
--boot

--[[if screen.Boot.Visible == false then
	screen.LoggedOff.Visible = false
	screen.LoggedOffOLD.Visible = falsea
	screen.Main.Visible = false
	screen.Boot.Visible = true
	wait(7)
	screen.Boot.Visible = false
	screen.LoggedOff.Visible = true
else
	screen.LoggedOff.Visible = false
	screen.LoggedOffOLD.Visible = false
	screen.Main.Visible = false
	screen.Boot.Visible = false
	screen.Boot.Visible = true
	wait(7)
	screen.Boot.Visible = false
	screen.LoggedOff.Visible = true
end]]

script.Parent.Screen.CardReader.Touched:Connect(function(hit)
	if swiperdeb then return end
	if hit:FindFirstChild("uPOS") then
		swiperdeb = true
		local plr = game.Players:GetPlayerFromCharacter(hit.Parent.Parent)
		user = plr.Name
		hit.Parent.Parent = game.ReplicatedStorage
		local originalposition = script.Parent.Screen.CardOrgPos.Position
		script.Parent.Screen.Card.Transparency = 0
		game.TweenService:Create(script.Parent.Screen.Card,TweenInfo.new(2.5,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{Position = script.Parent.Screen.CardGoal.Position}):Play()
		wait(2.5)
		script.Parent.Screen.CardReader.Sound:Play()
		script.Parent.Screen.Card.Position = originalposition
		script.Parent.Screen.Card.Transparency = 1
		loggedoffscreen.Visible = false
		cstrdispting.Parent.LoggedOff.Visible = false
		cstrdispting.Parent.Main.Visible = true
		screen.Main.Visible = true
		hit.Parent.Parent = plr.Backpack
	end
end)
screen.Main.Sidebar.logout.MouseButton1Click:Connect(function()
	user = nil
	loggedoffscreen.Visible = true
	screen.Main.Visible = false
	swiperdeb = false
	cstrdispting.Parent.LoggedOff.Visible = true
	cstrdispting.Parent.Main.Visible = false
	api:Fire("ResetTerminalSilent")
end)


script.Parent.AwareNetwork.Event:Connect(function(what,wat,title,context)
	if what == "AddItem" then
		if scandeb then return end
		if wat then
			local itemstuff
			wait(.1)
			itemstuff = {Name = wat,Price = title}
			local klon = main.ScrollingFrame.template:Clone()
			if tillsettings.HoldItems then
				title.Parent = folder
				table.insert(cafepositems,title)
			end
			
			klon.Parent = main.ScrollingFrame
			klon.Name = "something lololol"
			klon.namee.Text = itemstuff.Name
			-- if config.CurrencyPosition is set to End then put the itemstuff.Price first and at the end put the config.Currency when it's set to Begin then put config.Currency first and then itemstuff.Price
			if config.CurrencyPosition == "End" then
				klon.price.Text = itemstuff.Price..config.Currency
			elseif config.CurrencyPosition == "Begin" then
				klon.price.Text = config.Currency..itemstuff.Price
			end
			table.insert(items,itemstuff)
			klon.Visible = true
			local klon2 = cstrdispting.ScrollingFrame.template:Clone()
			klon2.Parent = cstrdispting.ScrollingFrame
			klon2.Name = "something lololol"
			klon2.namee.Text = itemstuff.Name
			if config.CurrencyPosition == "End" then
				klon2.price.Text = itemstuff.Price..config.Currency
			elseif config.CurrencyPosition == "Begin" then
				klon2.price.Text = config.Currency..itemstuff.Price
			end
			klon2.Visible = true
			total += tonumber(itemstuff.Price)
			itemamount += 1
		end
	elseif what == "AddItemHotkey" then
			if wat then
				local itemstuff
			wait(.1)
			if config.Hotkeys[wat][title] or config.Hotkeys[wat][tonumber(title)] then 
				itemstuff = config.Hotkeys[wat][title] or config.Hotkeys[wat][tonumber(title)]
					local klon = main.ScrollingFrame.template:Clone()
					klon.Parent = main.ScrollingFrame
					klon.Name = "something lololol"
					klon.namee.Text = itemstuff.Name
					klon.price.Text = itemstuff.Price..config.Currency
					table.insert(items,itemstuff)
					klon.Visible = true
					local klon2 = cstrdispting.ScrollingFrame.template:Clone()
					klon2.Parent = cstrdispting.ScrollingFrame
					klon2.Name = "something lololol"
					klon2.namee.Text = itemstuff.Name
					klon2.price.Text = itemstuff.Price..config.Currency
					klon2.Visible = true
					total += tonumber(itemstuff.Price)
					itemamount += 1
				end
			end
	elseif what == "Message" and wat and title and context then
		if wat == "warn" then
			game.TweenService:Create(main.Parent.Warning, TweenInfo.new(.75,Enum.EasingStyle.Cubic),{Position = UDim2.new(.145,0,.5,0)}):Play()
			main.Parent.Warning.Title.Text = title
			main.Parent.Warning.Content.Text = context
			main.Parent.Info.TextButton.Visible = true
			screen.Parent.warn:Play()
		elseif wat == "info" then
			main.Parent.Info.Title.Text = title
			main.Parent.Info.Content.Text = context
			main.Parent.Info.TextButton.Visible = true
			game.TweenService:Create(main.Parent.Info, TweenInfo.new(.75,Enum.EasingStyle.Cubic),{Position = UDim2.new(.145,0,.5,0)}):Play()
			screen.Parent.info:Play()
		elseif wat == "closedrawerthing" then
			main.Parent.Info.Title.Text = title
			main.Parent.Info.Content.Text = context
			main.Parent.Info.TextButton.Visible = false
			game.TweenService:Create(main.Parent.Info, TweenInfo.new(.75,Enum.EasingStyle.Cubic),{Position = UDim2.new(.145,0,.5,0)}):Play()
			screen.Parent.info:Play()
		end 
	elseif what == "ResetTerminal" then
		for i,v in pairs(main.ScrollingFrame:GetChildren()) do
			if v.Name ~= "template" and v:IsA("Frame") then
				v:Destroy()
			end
		end
		for i,v in pairs(cstrdispting.ScrollingFrame:GetChildren()) do
			if v.Name ~= "template" and v:IsA("Frame") then
				v:Destroy()
			end
		end
		main.SidebarPay.Visible = false
		main.Sidebar.Visible = true
		if require(script.Parent.TillSettings).settings.TransactionCompleteMsg == true then
			api:Fire("Message","info","Transaction Completed", "Next Customer Please")
		end
		scandeb = false
		total = 0
		itemamount = 0
		items = {}
	elseif what == "ResetTerminalSilent" then
		for i,v in pairs(main.ScrollingFrame:GetChildren()) do
			if v.Name ~= "template" and v:IsA("Frame") then
				v:Destroy()
			end
		end
		for i,v in pairs(cstrdispting.ScrollingFrame:GetChildren()) do
			if v.Name ~= "template" and v:IsA("Frame") then
				v:Destroy()
			end
		end
		main.SidebarPay.Visible = false
		main.Sidebar.Visible = true
		scandeb = false
		total = 0
		itemamount = 0
		items = {}

	elseif what == "General" and wat == "TransactionCompleted" then
		if tillsettings.HoldItems then
			for i,v in pairs(cafepositems) do
				v.Parent = title.Backpack
				table.remove(cafepositems,i)
			end
		end
		--if kitchen then
			screen.Parent.Parent.Parent.Parent.Parent.Addons.AddonAPI:Fire("NewOrder",items,73924)
		--end
		api:Fire("ResetTerminal")
		main.Info.Visible = false
	elseif what == "Close" then -- ended up being a shortcut for reset
		api:Fire("ResetTerminal")
	end
end)
main.Sidebar.subtotal.MouseButton1Click:Connect(function()
	if itemamount == 0 then
		api:Fire("Message","warn","Subtotal","No items, cannot pay!")return
	end
	main.Sidebar.Visible = false
	main.SidebarPay.price.Text = tostring(total)..gconfig.Currency
	main.SidebarPay.Visible = true
	scandeb = true
end)
main.SidebarPay.eft.MouseButton1Click:Connect(function()
	api:Fire("CardReader","Pay", total, items)
end)
main.Sidebar.void.MouseButton1Click:Connect(function()
	if itemamount == 0 then
		api:Fire("Message","warn","Void Transaction", "No items! Cannot void transaction.")
		return
	end
	api:Fire("ResetTerminal")
	api:Fire("Message","info","Void Transaction", "Transaction has been voided.")
end)
main.SidebarPay.returny.MouseButton1Click:Connect(function()
	scandeb = false
	main.Sidebar.Visible = true
	main.SidebarPay.Visible = false
end)

main.Sidebar.hotkey.MouseButton1Click:Connect(function()
	scandeb = true
	main.hotkeys.Visible = true
	main.Sidebar.Visible = false
end)
for i,v in pairs(gconfig.Hotkeys) do
	print("index is"..i)
	local that = main.templateforcategory:Clone()
	that.Name = i
	that.Parent = main
	local thatanother = main.hotkeys.template:Clone()
	thatanother.Name = i
	thatanother.Parent = main.hotkeys
	thatanother.Visible = true
	thatanother.TextLabel.Text = i
	thatanother.Image = "rbxassetid://"..v.ImageId
	thatanother.MouseButton1Click:Connect(function()
		main.hotkeys.Visible = false
		main:FindFirstChild(i).Visible = true
	end)
	for i2,v2 in pairs(v) do
		if i2 == "ImageId" then
			continue
		end
		local thatanothe2r = main.hotkeys.template:Clone()
		thatanothe2r.Name = i2
		thatanothe2r.Parent = that
		thatanothe2r.Visible = true
		thatanothe2r.TextLabel.Text = v2.Name
		thatanothe2r.Image = "rbxassetid://"..v2.ImageId
		thatanothe2r.MouseButton1Click:Connect(function()
			api:Fire("AddItemHotkey",i,i2)
		end)
	end
end

script.Parent.CustomerScreen.Screen.awareOS.Main.Sidebar.coupons.MouseButton1Click:Connect(function()
	script.Parent.CustomerScreen.Screen.awareOS.ScanCouponNotification.Visible = true
	-- {0.175, 0},{0.25, 0}
	game.TweenService:Create(main.Parent.Warning, TweenInfo.new(.5,Enum.EasingStyle.Cubic),{Position = UDim2.new(0.175,0,0.25,0)}):Play()
end)
