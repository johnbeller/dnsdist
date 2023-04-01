#!/usr/bin/env lua5.4

local socket = require("socket")

udp = socket.udp()
udp:setpeername("127.0.0.1", 53474)
udp:settimeout(10)

udp:send("?")
data = udp:receive()
if data then
    print("Received: ", data)
end

