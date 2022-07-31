local visualizer = {}

local camera = workspace.CurrentCamera

-- table.create seems to just not work with drawing classes
local function create_drawings_table(amount, drawingtype)
    local drawings = {}
    for i = 1, amount do
        table.insert(drawings, Drawing.new(drawingtype)) 
    end
    return drawings
end

local function clear_drawings(drawings)
    for _, drawing in pairs(drawings) do
        if drawing.ZIndex == nil then
            clear_drawings(drawing)
        else
            drawing:Remove()
        end
    end
end

function visualizer:VisualizePath(waypoints)
      local drawings = {
            Dots = create_drawings_table(#waypoints, 'Square');
            Lines = create_drawings_table(#waypoints, 'Line');
      }

      local lastpos
      local visualizeloop = game:GetService('RunService').RenderStepped:Connect(function()
            for i = 1, #waypoints do
                  local vector, onscreen = camera:WorldToViewportPoint(waypoints[i].Position)
                  local screenpos = Vector2.new(vector.X, vector.Y)

                  local dot = drawings.Dots[i]
                  dot.Size = Vector2.new(8, 8)
                  dot.Thickness = 1
                  dot.Filled = true
                  dot.Color = Color3.new(1, 1, 1)
                  dot.Position = screenpos - Vector2.new(dot.Size.X/2, dot.Size.Y/2)
                  dot.Visible = onscreen

                  if i ~= 1 then
                        local line = drawings.Lines[i]
                        line.Thickness = 1
                        line.Color = Color3.new(1, 1, 1)
                        line.From = lastpos
                        line.To = screenpos
                        line.Visible = onscreen
                  end

                  lastpos = screenpos

                  --print(#drawings.Dots, #drawing.Lines)
                  --print('index:', i, 'pos on screen:', screenpos)
            end
            game:GetService('RunService').RenderStepped:Wait()
      end)

      -- i could do a better implementation
      local functions = {}

      function functions:RemovePath()
            visualizeloop:Disconnect()
            clear_drawings(drawings)
      end

      return functions
end

return visualizer