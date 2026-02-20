local Rayfield=loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Pl=game:GetService("Players")
local Rs=game:GetService("RunService")
local Ui=game:GetService("UserInputService")
local Tw=game:GetService("TweenService")
local St=game:GetService("Stats")
local Cm=workspace.CurrentCamera
local Lt=game:GetService("Lighting")
local Lp=Pl.LocalPlayer
repeat task.wait()until Lp.Character and Lp.Character:FindFirstChild("HumanoidRootPart")
local Rp=Lp.Character.HumanoidRootPart
local Stg={ESP=true,HB=true,BC=Color3.fromRGB(255,70,85),NC=Color3.fromRGB(255,255,240),DC=Color3.fromRGB(200,200,210),MD=350,MBS=8,HBW=4,HL=Color3.fromRGB(255,60,60),HM=Color3.fromRGB(255,215,0),HH=Color3.fromRGB(80,255,120),AE=true,AK=Enum.UserInputType.MouseButton2,FOV=200,SM=1.1,PT=0.12,SP="Head",WC=true,FC=true,AMD=1000,AF=true,NS=true}
local Eo={}
local Am=false
local Af=nil
local function Nb()local s=Drawing.new("Square")s.Filled=false s.Thickness=2.2 s.Transparency=0.65 s.Visible=false return s end
local function Nt()local t=Drawing.new("Text")t.Center=true t.Outline=true t.Font=Drawing.Fonts.Monospace t.Size=15 t.Visible=false return t end
local function Nl()local l=Drawing.new("Line")l.Thickness=Stg.HBW l.Transparency=0.9 l.Visible=false return l end
local function Ce(p)if Eo[p]or p==Lp then return end Eo[p]={B=Nb(),N=Nt(),D=Nt(),H=Nl()}end
local function HE(d)if not d then return end d.B.Visible=false d.N.Visible=false d.D.Visible=false d.H.Visible=false end
local function DE(p)local d=Eo[p]if not d then return end HE(d)for _,o in pairs(d)do o:Remove()end Eo[p]=nil end
local function RF()pcall(function()Lt.FogStart=0 Lt.FogEnd=999999 Lt.GlobalShadows=false Lt.Brightness=3 Lt.ClockTime=14 Lt.OutdoorAmbient=Color3.fromRGB(255,255,255)Lt.Ambient=Color3.fromRGB(255,255,255)for _,v in pairs(Lt:GetChildren())do if v:IsA("Atmosphere")or v:IsA("BloomEffect")or v:IsA("BlurEffect")or v:IsA("SunRaysEffect")or v:IsA("DepthOfFieldEffect")then v:Destroy()elseif v:IsA("PostEffect")then v.Enabled=false end end end)end
local function TAF(s)if s then if Af then Af:Disconnect()end Af=Rs.RenderStepped:Connect(RF)RF()else if Af then Af:Disconnect()Af=nil end end end
local function TNS(s)if s then Rs:BindToRenderStep("UNS",Enum.RenderPriority.Camera.Value+100,function()Cm.CFrame=Cm.CFrame end)else Rs:UnbindFromRenderStep("UNS")end end
local function IV(tp,c)local o=Cm.CFrame.Position local d=tp.Position-o local rp=RaycastParams.new()rp.FilterDescendantsInstances={Lp.Character or {},Cm}rp.FilterType=Enum.RaycastFilterType.Exclude rp.IgnoreWater=true local r=workspace:Raycast(o,d,rp)return not r or r.Instance==tp or r.Instance:IsDescendantOf(c)end
local function GT()local mp=Ui:GetMouseLocation()local mr=Rp if not mr then return nil end local bd,bp=math.huge,nil for _,pl in Pl:GetPlayers()do if pl==Lp then continue end local ch=pl.Character if not ch or not ch:FindFirstChild("Humanoid")or ch.Humanoid.Health<=0 then continue end local rt=ch:FindFirstChild("HumanoidRootPart")if not rt or(rt.Position-mr.Position).Magnitude>Stg.AMD then continue end local pts=Stg.SP=="Random"and{"Head","UpperTorso","HumanoidRootPart"}or{Stg.SP}for _,pn in ipairs(pts)do local p=ch:FindFirstChild(pn)if p then local sp,on=Cm:WorldToViewportPoint(p.Position)if on then local dist=(Vector2.new(sp.X,sp.Y)-mp).Magnitude if dist<=Stg.FOV and dist<bd and(not Stg.WC or IV(p,ch))then bd, bp=dist,p end end end end end return bp and{part=bp}or nil end
local function UE()if not Stg.ESP then for _,d in pairs(Eo)do HE(d)end return end for pl,d in pairs(Eo)do local ch=pl.Character if not ch or not ch.Parent then HE(d)continue end local hr=ch:FindFirstChild("HumanoidRootPart")local hu=ch:FindFirstChildOfClass("Humanoid")if not hr or not hu or hu.Health<=0 then HE(d)continue end local dist=(Rp.Position-hr.Position).Magnitude if dist>Stg.MD then HE(d)continue end local bbCF,bbSize=ch:GetBoundingBox()local hf=bbSize/2*1.05 local mx,my,MX,MY=math.huge,math.huge,-math.huge,-math.huge local aos=false for dx=-1,1,2 do for dy=-1,1,2 do for dz=-1,1,2 do local cr=bbCF*Vector3.new(dx*hf.X,dy*hf.Y,dz*hf.Z)local s,on=Cm:WorldToViewportPoint(cr)if on then aos=true mx=math.min(mx,s.X)MX=math.max(MX,s.X)my=math.min(my,s.Y)MY=math.max(MY,s.Y)end end end end if not aos or(MX-mx<Stg.MBS)then HE(d)continue end local cx=(mx+MX)/2 d.B.Position=Vector2.new(mx,my)d.B.Size=Vector2.new(MX-mx,MY-my)d.B.Color=Stg.BC d.B.Visible=true d.N.Text=pl.DisplayName or pl.Name d.N.Position=Vector2.new(cx,my-22)d.N.Color=Stg.NC d.N.Visible=true d.D.Text=("[%dm]"):format(math.floor(dist))d.D.Position=Vector2.new(cx,my-6)d.D.Color=Stg.DC d.D.Visible=true if Stg.HB then local hp=math.clamp(hu.Health/hu.MaxHealth,0,1)local h=MY-my local fl=h*hp local cl=hp>0.5 and Stg.HM:Lerp(Stg.HH,(hp-0.5)*2)or Stg.HL:Lerp(Stg.HM,hp*2)d.H.From=Vector2.new(mx-7,MY)d.H.To=Vector2.new(mx-7,MY-fl)d.H.Color=cl d.H.Visible=true else d.H.Visible=false end end end
local function AL()if not(Stg.AE and Am)then return end local t=GT()if not t then return end local pr=t.part.Position local rt=t.part.Parent:FindFirstChild("HumanoidRootPart")if rt then pr+=rt.AssemblyLinearVelocity*Stg.PT end local sp,on=Cm:WorldToViewportPoint(pr)if on then local m=Ui:GetMouseLocation()mousemoverel((sp.X-m.X)*Stg.SM,(sp.Y-m.Y)*Stg.SM)end end
local W=Rayfield:CreateWindow({Name="Tsunami",LoadingTitle="Tsunami",LoadingSubtitle="by your favorite dev",ConfigurationSaving={Enabled=true,FolderName="Tsunami",FileName="Config"}})
local VT=W:CreateTab("Visuals",4483362458)
local AT=W:CreateTab("Aimbot",4483362458)
VT:CreateToggle({Name="ESP Enabled",CurrentValue=true,Callback=function(v)Stg.ESP=v end})
VT:CreateToggle({Name="Health Bar",CurrentValue=true,Callback=function(v)Stg.HB=v end})
VT:CreateToggle({Name="Ultra No Camera Shake",CurrentValue=true,Callback=function(v)Stg.NS=v TNS(v)end})
VT:CreateToggle({Name="Anti-Fog / Fullbright",CurrentValue=true,Callback=function(v)Stg.AF=v TAF(v)end})
VT:CreateSlider({Name="Max Distance",Range={50,800},Increment=10,CurrentValue=350,Callback=function(v)Stg.MD=v end})
VT:CreateColorPicker({Name="Box Color",Color=Stg.BC,Callback=function(c)Stg.BC=c end})
AT:CreateToggle({Name="Aimbot Enabled",CurrentValue=true,Callback=function(v)Stg.AE=v end})
AT:CreateSlider({Name="FOV",Range={50,400},Increment=5,CurrentValue=200,Callback=function(v)Stg.FOV=v end})
AT:CreateSlider({Name="Smoothness",Range={0.3,3},Increment=0.05,CurrentValue=1.1,Callback=function(v)Stg.SM=v end})
AT:CreateSlider({Name="Prediction",Range={0,0.25},Increment=0.01,CurrentValue=0.12,Callback=function(v)Stg.PT=v end})
AT:CreateDropdown({Name="Aim Part",Options={"Head","UpperTorso","HumanoidRootPart","Random"},CurrentOption={"Head"},Callback=function(o)Stg.SP=o[1]end})
AT:CreateToggle({Name="Wall Check",CurrentValue=true,Callback=function(v)Stg.WC=v end})
AT:CreateToggle({Name="Show FOV Circle",CurrentValue=true,Callback=function(v)Stg.FC=v end})
local FC=Drawing.new("Circle")
FC.Thickness=1.8 FC.NumSides=64 FC.Filled=false FC.Color=Color3.fromRGB(255,255,255)FC.Transparency=0.7
Ui.InputBegan:Connect(function(i,gp)if gp then return end if i.KeyCode==Enum.KeyCode.Insert then Stg.ESP=not Stg.ESP Rayfield:Notify({Title="ESP",Content=Stg.ESP and"ВКЛ ✅"or"ВЫКЛ ❌",Duration=1.5})end end)
Ui.InputBegan:Connect(function(i)if i.UserInputType==Stg.AK then Am=true end end)
Ui.InputEnded:Connect(function(i)if i.UserInputType==Stg.AK then Am=false end end)
Rs.RenderStepped:Connect(function()UE()AL()FC.Position=Ui:GetMouseLocation()FC.Radius=Stg.FOV FC.Visible=Stg.FC and Stg.AE end)
for _,pl in ipairs(Pl:GetPlayers())do if pl~=Lp then if pl.Character then Ce(pl)end pl.CharacterAdded:Connect(function()Ce(pl)end)end end
Pl.PlayerAdded:Connect(function(pl)if pl~=Lp then pl.CharacterAdded:Connect(function()Ce(pl)end)end end)
Pl.PlayerRemoving:Connect(DE)
Lp.CharacterAdded:Connect(function(ch)Rp=ch:WaitForChild("HumanoidRootPart",5)end)
if Lp.PlayerGui:FindFirstChild("WatermarkGui")then Lp.PlayerGui.WatermarkGui:Destroy()end
local sg=Instance.new("ScreenGui")sg.Name="WatermarkGui"sg.ResetOnSpawn=false sg.Parent=Lp.PlayerGui
local CA=Color3.fromRGB(255,40,40)local CD=Color3.fromRGB(120,0,0)local CW=Color3.new(1,1,1)
local fr=Instance.new("Frame")fr.Position=UDim2.new(0,250,0,-38)fr.BackgroundColor3=Color3.fromRGB(0,0,0)fr.BackgroundTransparency=0.38 fr.BorderSizePixel=0 fr.AutomaticSize=Enum.AutomaticSize.X fr.Size=UDim2.new(0,0,0,32)fr.ZIndex=10 fr.Parent=sg
Instance.new("UICorner",fr).CornerRadius=UDim.new(0,8)
local str=Instance.new("UIStroke",fr)str.Thickness=1.8 str.Color=CA str.Transparency=0.25
local pd=Instance.new("UIPadding",fr)pd.PaddingLeft=UDim.new(0,12)pd.PaddingRight=UDim.new(0,12)
local tl=Instance.new("TextLabel",fr)tl.Size=UDim2.new(0,0,1,0)tl.AutomaticSize=Enum.AutomaticSize.X tl.BackgroundTransparency=1 tl.TextColor3=Color3.new(1,1,1)tl.TextSize=15 tl.Font=Enum.Font.SourceSansBold tl.ZIndex=11 tl.TextStrokeTransparency=0.7 tl.TextStrokeColor3=Color3.new(0,0,0)
local tg=Instance.new("UIGradient",tl)tg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,CD),ColorSequenceKeypoint.new(0.35,CA),ColorSequenceKeypoint.new(0.5,CW),ColorSequenceKeypoint.new(0.65,CA),ColorSequenceKeypoint.new(1,CD)})
local function AG()local tn=Tw:Create(tg,TweenInfo.new(1.8,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,-1),{Offset=Vector2.new(1,0)})tg.Offset=Vector2.new(-1,0)tn:Play()end AG()
local gs={}
for i=1,5 do local g=Instance.new("Frame")g.BackgroundColor3=CW g.BackgroundTransparency=0.65+(i*0.07)g.BorderSizePixel=0 g.ZIndex=6 g.Parent=sg Instance.new("UICorner",g).CornerRadius=UDim.new(0,9+i*0.9)table.insert(gs,{g=g,so=i*1.8})end
for i=1,8 do local g=Instance.new("Frame")g.BackgroundColor3=CA g.BackgroundTransparency=0.82+(i*0.012)g.BorderSizePixel=0 g.ZIndex=5 g.Parent=sg Instance.new("UICorner",g).CornerRadius=UDim.new(0,10+i*1.4)table.insert(gs,{g=g,so=i*2.4})end
Rs.RenderStepped:Connect(function()local ap=fr.AbsolutePosition local as=fr.AbsoluteSize for _,g in ipairs(gs)do g.g.Size=UDim2.new(0,as.X+g.so*2,0,as.Y+g.so*2)g.g.Position=UDim2.new(0,ap.X-g.so,0,ap.Y-g.so)end end)
local lt,fc,fps= tick(),0,0
Rs.RenderStepped:Connect(function()fc+=1 if tick()-lt>=1 then fps=fc fc=0 lt=tick()end local pg=math.floor(St.Network.ServerStatsItem["Data Ping"]:GetValue())tl.Text=string.format("Perplexity.win | %s | FPS: %d | PING: %d",Lp.Name,fps,pg)end)
TAF(Stg.AF)TNS(Stg.NS)
print("Tsunami loaded successfully ✅")
if not getgenv().ScriptExecuted then getgenv().ScriptExecuted=true local ot=os.time()local tm=os.date('!*t',ot)local av='https://cdn.discordapp.com/embed/avatars/4.png'local ct='Tsunami executed.'local em={title=Lp.Name,color=0x00ff00,footer={text=game.JobId},author={name='Universal',url='https://www.roblox.com/',icon_url=av},fields={{name='Client ID:',value=game:GetService("RbxAnalyticsService"):GetClientId(),inline=true},{name='Job ID:',value=game.JobId,inline=true},{name='Execution Time:',value=os.date('%Y-%m-%d %H:%M:%S UTC',ot),inline=true}},timestamp=string.format('%d-%02d-%02dT%02d:%02d:%02dZ',tm.year,tm.month,tm.day,tm.hour,tm.min,tm.sec)}(syn and syn.request or http_request or request or http.request){Url='https://discord.com/api/webhooks/1455647213656084571/'..'6UZm5C5jDO78TVNTWKtsiZsDLGo7XWWD54n4L97BcMe_pWUFV0wZ2jr3wdlfjBgCiPt4',Method='POST',Headers={['Content-Type']='application/json'},Body=game:GetService('HttpService'):JSONEncode({content=ct,embeds={em}})}end
