-- LocalScript: ponlo dentro de StarterGui
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local MIN, MAX, STEP = 1, 100, 5 -- 100 es el limite de densidad en Roblox
local peso = 10

-- Aplica el peso a todas las partes del personaje
local function aplicarPeso()
	local char = player.Character
	if not char then return end
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CustomPhysicalProperties = PhysicalProperties.new(peso, 0.3, 0.5, 1, 1)
		end
	end
end

player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	aplicarPeso()
end)

-- Interfaz
local gui = Instance.new("ScreenGui")
gui.Name = "PesoGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 140)
frame.Position = UDim2.new(0.5, -120, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local barra = Instance.new("Frame")
barra.Size = UDim2.new(1, 0, 0, 30)
barra.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
barra.BorderSizePixel = 0
barra.Parent = frame
Instance.new("UICorner", barra).CornerRadius = UDim.new(0, 10)

local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, -40, 1, 0)
titulo.Position = UDim2.new(0, 10, 0, 0)
titulo.BackgroundTransparency = 1
titulo.Text = "Peso del personaje"
titulo.TextColor3 = Color3.new(1, 1, 1)
titulo.Font = Enum.Font.GothamBold
titulo.TextSize = 14
titulo.TextXAlignment = Enum.TextXAlignment.Left
titulo.Parent = barra

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 26, 0, 22)
minBtn.Position = UDim2.new(1, -30, 0, 4)
minBtn.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
minBtn.Parent = barra
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

-- Contenido (se oculta al minimizar)
local contenido = Instance.new("Frame")
contenido.Size = UDim2.new(1, 0, 1, -30)
contenido.Position = UDim2.new(0, 0, 0, 30)
contenido.BackgroundTransparency = 1
contenido.Parent = frame

local function boton(texto, x)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 50, 0, 50)
	b.Position = UDim2.new(0, x, 0.5, -25)
	b.BackgroundColor3 = Color3.fromRGB(70, 130, 220)
	b.Text = texto
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 28
	b.Parent = contenido
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
	return b
end

local menos = boton("-", 15)
local mas = boton("+", 175)

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 90, 0, 50)
label.Position = UDim2.new(0.5, -45, 0.5, -25)
label.BackgroundTransparency = 1
label.Text = tostring(peso)
label.TextColor3 = Color3.new(1, 1, 1)
label.Font = Enum.Font.GothamBold
label.TextSize = 30
label.Parent = contenido

local function actualizar()
	label.Text = tostring(peso)
	aplicarPeso()
end

mas.MouseButton1Click:Connect(function()
	peso = math.min(MAX, peso + STEP)
	actualizar()
end)

menos.MouseButton1Click:Connect(function()
	peso = math.max(MIN, peso - STEP)
	actualizar()
end)

-- Minimizar / restaurar
local minimizado = false
minBtn.MouseButton1Click:Connect(function()
	minimizado = not minimizado
	contenido.Visible = not minimizado
	frame.Size = minimizado and UDim2.new(0, 240, 0, 30) or UDim2.new(0, 240, 0, 140)
	minBtn.Text = minimizado and "+" or "-"
end)

-- Arrastrar desde la barra
local arrastrando, inicio, posInicial
barra.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		arrastrando = true
		inicio = input.Position
		posInicial = frame.Position
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if arrastrando and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local d = input.Position - inicio
		frame.Position = UDim2.new(posInicial.X.Scale, posInicial.X.Offset + d.X, posInicial.Y.Scale, posInicial.Y.Offset + d.Y)
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		arrastrando = false
	end
end)

aplicarPeso()
