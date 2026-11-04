local enet = require("enet")

local Networker = {}
Networker.__index = Networker

function Networker.new_server(address, port, maxClients)
    local self = setmetatable({}, Networker)
    self.host = enet.host_create((address or "localhost")..":"..(port or "6789"), maxClients or 32, 2, 0, 0)
    self.isServer = true
    return self
end

function Networker.new_client(address, port)
    local self = setmetatable({}, Networker)
    self.host = enet.host_create(nil, 1, 2, 0, 0)
    self.serverPeer = self.host:connect((address or "localhost")..":"..(port or "6789"), 2)
    self.isServer = false
    return self
end

function Networker:update(timeout, callback)
    local event = self.host:service(timeout or 0)
    while event do 
        if callback then
            callback(event.type, event.peer, event.data)
        end
        event = self.host:service(0)
    end 
end

function Networker:send(data, peer)
    if self.isServer then
        if peer then
            peer:send(data)
        else
            self.host:broadcast(data)
        end
    else
        if self.serverPeer then
            self.serverPeer:send(data)
        end
    end 
end

function Networker:close()
    self.host:destroy()
end

return Networker