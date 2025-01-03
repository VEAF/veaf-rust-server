--
-- RPC VEAF alias actions
-- https://veaf.github.io/documentation/
--

local GRPC = GRPC
local lfs = require("lfs")

local methods = {}
function methods.GetAliases()
  local result = {}

  if veaf and veafShortcuts then
    local aliases = veafShortcuts.getAliasesList()
    for _, alias in pairs(aliases) do
      table.insert(result, GRPC.exporters.alias(alias))
    end
  end

  return GRPC.success({aliases = result})
end

function methods.GetAlias(params)
  local alias = veafShortcuts.getByName(params.name)
  if alias == nil then
    return GRPC.errorNotFound("alias `" .. tostring(params.name) .. "` does not exist")
  end

  return GRPC.success({alias = GRPC.exporters.alias(alias)})
end

function methods.RunAlias(params)
  local alias = veafShortcuts.getByName(params.name)
  if alias == nil then
    return GRPC.errorNotFound("alias `" .. tostring(params.name) .. "` does not exist")
  end
  local point = coord.LLtoLO(params.position.lat, params.position.lon, params.position.alt)
  
  return GRPC.success({alias = GRPC.exporters.alias(alias)})
end
local exporters = {}

exporters.alias = function(alias)
  return {
    name = alias:getName(),
    description = alias:getDescription(),
    command = alias:getVeafCommand(),
  }
end
