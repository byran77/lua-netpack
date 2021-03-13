local strsub = string.sub
local strpack = string.pack
local strunpack = string.unpack

local MSG_FLAG_ENCRYPT   = 0x1
local MSG_FLAG_COMPRESS  = 0x2
local MSG_FLAG_BROADCAST = 0x4
local MSG_FLAG_CLIENT    = 0x8

local net_pack = {}
net_pack.__index = net_pack


function net_pack.new()
    local self = {
        wDataLen = 0,
        byFlag = 0,
        pData = nil,
    }

    setmetatable(self, net_pack)

    return self
end

--Pack the data and return the packet
function net_pack.pack_data(data, flag)
    local dlen = #data
    return strpack("<I2I1c"..dlen, dlen, flag or 0, data)
end

--Parse the packet and return net_pack object & left data
function net_pack.parse_data(data)
    local dlen = #data

    if dlen < 3 then 
        return
    end

    local len, flag = strunpack("<I2I1", data)
    if not len or not flag or (len + 3) > dlen then
        return
    end

    local self = {
        wDataLen = len,
        byFlag = flag,
        pData = strsub(data, 4, len + 3)
    }

    setmetatable(self, net_pack)

    return self, strsub(data, len + 4, -1)
end

--Test the flag bit
function net_pack:is_encrypt()
    return (self.byFlag & MSG_FLAG_ENCRYPT) > 0
end

function net_pack:is_compress()
    return (self.byFlag & MSG_FLAG_COMPRESS) > 0
end

function net_pack:is_broadcast()
    return (self.byFlag & MSG_FLAG_BROADCAST) > 0
end

--Set the flag bit
function net_pack:set_encrypt()
    self.byFlag = self.byFlag | MSG_FLAG_ENCRYPT
end

function net_pack:set_compress()
    self.byFlag = self.byFlag | MSG_FLAG_COMPRESS
end

function net_pack:set_broadcast()
    self.byFlag = self.byFlag | MSG_FLAG_BROADCAST
end

function net_pack:set_data(data)
    self.wDataLen = #data
    self.pData = data
end

function net_pack:pack()
    if self.wDataLen > 0 then
        return net_pack.pack_data(self.pData, self.byFlag)
    end
end

return net_pack
