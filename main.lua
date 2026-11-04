io.stdout:setvbuf("no")

local Networker = require("src.shared.networker")

local server
local client

local function server_callback(type, peer, data)
    if type == "connect" then print("Somebody connected to us:", peer:index()) end
    if type == "receive" then print("Somebody sent us something:", data) end
end

local function client_callback(type, peer, data)
    if type == "receive" then print("Client got something from server:", data) end
end

function love.load()
    server = Networker.new_server("127.0.0.1", 12345, 2)
    client = Networker.new_client("127.0.0.1", 12345)
end

function love.update()
    server:update(0, server_callback)
    server:update(0, client_callback)
end

