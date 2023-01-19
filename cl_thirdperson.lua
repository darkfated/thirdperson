CreateClientConVar('third_person', 0, true)
CreateClientConVar('third_person_ud', 0, true, false, '', -15, 15)
CreateClientConVar('third_person_rl', 0, true, false, '', -20, 20)
CreateClientConVar('third_person_fb', -60, true, false, '', -120, 30)
CreateClientConVar('third_person_ang', 0, true, false, '', -45, 45)

hook.Add('ShouldDrawLocalPlayer', 'FrelDrawPlayer', function()
	if GetConVar('third_person'):GetBool() then
		return not LocalPlayer():InVehicle()
	end
end)

hook.Add('CalcView', 'FrelCalcView', function(pl, origin, ang, fov)
	if GetConVar('third_person'):GetBool() and not pl:InVehicle() then
		return {
			origin = util.TraceLine({
				start = origin,
				endpos = origin + (ang:Up() * GetConVar('third_person_ud'):GetInt()) + (ang:Right() * GetConVar('third_person_rl'):GetInt()) + (ang:Forward() * GetConVar('third_person_fb'):GetInt()),
				filter = pl,
			}).HitPos + (ang:Forward() * 16),
			angles = Vector(ang.x, ang.y, ang.z + GetConVar('third_person_ang'):GetInt()),
			fov = fov,
		}
	end
end)

local color_header = Color(69,69,69)
local color_background = Color(54,54,54)
local color_close = Color(253,116,92)

concommand.Add('person_menu', function()
	local menu = vgui.Create('DFrame')
	menu:SetSize(math.min(300, ScrW() * 0.2), 175)
	menu:Center()
	menu:MakePopup()
	menu:ShowCloseButton(false)
	menu:SetTitle('Third Person Settings')
	menu.Paint = function(_, w, h)
		draw.RoundedBox(8, 0, 0, w, h, color_background)
		draw.RoundedBoxEx(8, 0, 0, w, 24, color_header, true, true, false, false)
	end

	local cls = vgui.Create('DButton', menu)
	cls:SetSize(16, 16)
	cls:SetPos(menu:GetWide() - cls:GetWide() - 4, 4)
	cls:SetText('')
	cls.DoClick = function()
		menu:Close()
	end
	cls.Paint = function(_, w, h)
		draw.RoundedBox(50, 0, 0, w, h, color_close)
	end

	local Checkbox = menu:Add('DCheckBoxLabel')
	Checkbox:Dock(TOP)
	Checkbox:DockMargin(0, 2, 0, 0)
	Checkbox:SetText('Enable the third person')
	Checkbox:SetConVar('third_person')

	local slider_ud = vgui.Create('DNumSlider', menu)
	slider_ud:Dock(TOP)
	slider_ud:DockMargin(2, 0, 0, 0)
	slider_ud:SetText('Up/down position')
	slider_ud:SetMin(-15)
	slider_ud:SetMax(15)
	slider_ud:SetDecimals(0)
	slider_ud:SetConVar('third_person_ud')

	local slider_rl = vgui.Create('DNumSlider', menu)
	slider_rl:Dock(TOP)
	slider_rl:DockMargin(2, 0, 0, 0)
	slider_rl:SetText('Right/left position')
	slider_rl:SetMin(-20)
	slider_rl:SetMax(20)
	slider_rl:SetDecimals(0)
	slider_rl:SetConVar('third_person_rl')

	local slider_fb = vgui.Create('DNumSlider', menu)
	slider_fb:Dock(TOP)
	slider_fb:DockMargin(2, 0, 0, 0)
	slider_fb:SetText('Forward/back position')
	slider_fb:SetMin(-120)
	slider_fb:SetMax(-30)
	slider_fb:SetDecimals(0)
	slider_fb:SetConVar('third_person_fb')

	local slider_ang = vgui.Create('DNumSlider', menu)
	slider_ang:Dock(TOP)
	slider_ang:DockMargin(2, 0, 0, 0)
	slider_ang:SetText('Camera rotation')
	slider_ang:SetMin(-45)
	slider_ang:SetMax(45)
	slider_ang:SetDecimals(0)
	slider_ang:SetConVar('third_person_ang')
end)

// For Sandbox

list.Set('DesktopWindows', 'PersonMenu', {
	title = 'Third Person',
	icon = 'icon16/cake.png',
	onewindow = false,
	init = function()
		RunConsoleCommand('person_menu')
	end,
})
