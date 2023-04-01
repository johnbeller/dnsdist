#!/usr/bin/env lua5.4

local socket = require("socket")

udp = assert(socket.udp())
udp:setsockname("*", 53474)
udp:settimeout(1)

status = 1	-- default: enabled

function all_trim(s)
  return s:match"^%s*(.*)":match"(.-)%s*$"
end


while true do
    data, ip, port = udp:receivefrom()
    if data then
    	data = all_trim(data)
--        print("Received: ", data, ip, port)
	if data == "0" then
		status = 0
	elseif data == "?" then
		-- do nothing, just give back status
	else
		status = 1
	end
	udp:sendto( tostring(status), ip, port )
--        print("Status: ", tostring(status), ip, port)
    end
    socket.sleep(0.01)
end
