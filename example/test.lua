package.path = package.path..";../?.lua"
local net_pack = require"net_pack"

local pack = net_pack.new()     --Create a packet object
--[[
pack.wDataLen = 
pack.byFlag = 
pData =

write(pack:pack())     
--]]                            --Send the packet

--[[
local data = read()             --Receive the data
--]]

local pack = net_pack.unpack_data(data) --Parse the received data 