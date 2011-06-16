local Libra = LibStub:GetLibrary('Libra-alpha', true)
if not Libra then return end

SlickTimers_MainGUI = Libra.UI.Window:Create(UIParent)
local MainGUI = SlickTimers_MainGUI 

-------------------------------------
-- Build the Main window
-------------------------------------
MainGUI.Timers = Libra.UI.FrameManager:Create('SlickTimers Timer Frame', MainGUI)

MainGUI:SetTitle('SlickTimers')
MainGUI.content.padding = 0

MainGUI.controlbox.new = Libra.UI.FrameManager:Create('Texture', MainGUI)
MainGUI.controlbox.new:SetPoint('TOPRIGHT', MainGUI.controlbox.close, 'TOPLEFT', -1 , 0)
MainGUI.controlbox.new:SetHeight(MainGUI.controlbox.close:GetHeight())
MainGUI.controlbox.new:SetWidth(MainGUI.controlbox.close:GetHeight())
MainGUI.controlbox.new:SetTexture('Libra', 'Media/add.tga')
MainGUI.controlbox.new:SetLayer(3)

MainGUI.controlbox.options = Libra.UI.FrameManager:Create('Texture', MainGUI)
MainGUI.controlbox.options:SetPoint('TOPRIGHT', MainGUI.controlbox.new, 'TOPLEFT', -1 , 0)
MainGUI.controlbox.options:SetHeight(MainGUI.controlbox.close:GetHeight())
MainGUI.controlbox.options:SetWidth(MainGUI.controlbox.close:GetHeight())
MainGUI.controlbox.options:SetTexture('Libra', 'Media/options.tga')
MainGUI.controlbox.options:SetLayer(3)

MainGUI:SetContent(MainGUI.Timers)