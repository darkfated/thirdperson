CreateClientConVar( 'third_person', 0, true )
CreateClientConVar( 'third_person_ud', 0, true )
CreateClientConVar( 'third_person_rl', 0, true )
CreateClientConVar( 'third_person_fb', -30, true )

hook.Add( 'ShouldDrawLocalPlayer', 'FrelDrawPlayer', function()
	if ( GetConVar( 'third_person' ):GetBool() ) then
		return not LocalPlayer():InVehicle()
	end
end )

hook.Add( 'CalcView', 'FrelCalcView', function( pl, origin, ang, fov )
	if ( GetConVar( 'third_person' ):GetBool() and not pl:InVehicle() ) then
		return {
			origin = util.TraceLine( {
				start = origin,
				endpos = origin + ( ang:Up() * GetConVar( 'third_person_ud' ):GetInt() ) + ( ang:Right() * GetConVar( 'third_person_rl' ):GetInt() ) + ( ang:Forward() * GetConVar( 'third_person_fb' ):GetInt() ),
				filter = pl,
			} ).HitPos + ( ang:Forward() * 16 ),
			angles = ang,
			fov = fov,
		}
	end
end )

concommand.Add( 'person_menu', function()
	local menu = vgui.Create( 'DFrame' )
	menu:SetSize( math.min( 300, ScrW() * 0.2 ), 144 )
	menu:Center()
	menu:MakePopup()
	menu:ShowCloseButton( false )
	menu:SetTitle( 'Third Person Settings' )
	menu.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, Color(54,54,54) )
		draw.RoundedBox( 8, 0, 0, w, 24, Color(69,69,69) )
		draw.RoundedBox( 0, 0, 16, w, 8, Color(69,69,69) )
	end

	local cls = vgui.Create( 'DButton', menu )
	cls:SetSize( 16, 16 )
	cls:SetPos( menu:GetWide() - cls:GetWide() - 4, 4 )
	cls:SetText( '' )
	cls.DoClick = function()
		menu:Close()
	end
	cls.Paint = function( self, w, h )
		draw.RoundedBox( 50, 0, 0, w, h, Color(253,116,92))
	end

	local Checkbox = menu:Add( 'DCheckBoxLabel' )
	Checkbox:Dock( TOP )
	Checkbox:DockMargin( 0, 2, 0, 0 )
	Checkbox:SetText( 'Enable the third person' )
	Checkbox:SetConVar( 'third_person' )

	local slider_ud = vgui.Create( 'DNumSlider', menu )
	slider_ud:Dock( TOP )
	slider_ud:DockMargin( 2, 0, 0, 0 )
	slider_ud:SetText( 'Up/down position' )
	slider_ud:SetMin( -15 )
	slider_ud:SetMax( 15 )
	slider_ud:SetDecimals( 0 )
	slider_ud:SetConVar( 'third_person_ud' )

	local slider_rl = vgui.Create( 'DNumSlider', menu )
	slider_rl:Dock( TOP )
	slider_rl:DockMargin( 2, 0, 0, 0 )
	slider_rl:SetText( 'Right/left position' )
	slider_rl:SetMin( -20 )
	slider_rl:SetMax( 20 )
	slider_rl:SetDecimals( 0 )
	slider_rl:SetConVar( 'third_person_rl' )

	local slider_fb = vgui.Create( 'DNumSlider', menu )
	slider_fb:Dock( TOP )
	slider_fb:DockMargin( 2, 0, 0, 0 )
	slider_fb:SetText( 'Forward/back position' )
	slider_fb:SetMin( -120 )
	slider_fb:SetMax( -30 )
	slider_fb:SetDecimals( 0 )
	slider_fb:SetConVar( 'third_person_fb' )
end )
