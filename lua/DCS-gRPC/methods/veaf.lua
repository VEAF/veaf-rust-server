--
-- load all the RPC VEAF actions
-- https://veaf.github.io/documentation/
--

local GRPC = GRPC
local lfs = require("lfs")

for file in lfs.dir("veaf/") do
  if file:match("%.lua$") then
    local filePath = "veaf/" .. file
    local chunk = loadfile(filePath)
    if chunk then
      local env = {}
      setfenv(chunk, env)
      pcall(chunk)
      for name, func in pairs(env) do
        if type(func) == "function" then
          local methodName = "veaf"..name
          GRPC.methods[methodName] = func
        end
      end
    end
  end
end
