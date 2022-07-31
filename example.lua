local visualizer = require(PathVisualizer)

local pfs = game:GetService('PathfindingService')
local char = game:GetService('Players').LocalPlayer.Character
local hum = char:FindFirstChild('Humanoid')

local path = pfs:CreatePath()
path:ComputeAsync(Vector3.new(), Vector3.new(50, 0, 50))
if path.Status == Enum.PathStatus.Success then
  local waypoints = path:GetWaypoints()
  local visualizedpath = visualizer:VisualizePath(waypoints)
  for _, waypoint in pairs(waypoints) do
    hum:MoveTo(waypoint.Position)
    if waypoint.Action == Enum.PathWaypointAction.Jump then
      hum.Jump = true
    end
    hum.MoveToFinished:Wait(0)
  end
  visualizedpath:RemovePath()
end
