require('ds18b20')

port = 80

-- ESP-01 GPIO Mapping
gpio0 = 3

ds18b20.setup(gpio0)



function sendData()

t1=ds18b20.read()
t1=ds18b20.read()
print("Temp:"..t1.." C\n")

-- conection to thingspeak.com
print("Sending data to thingspeak.com")
conn=net.createConnection(net.TCP, 0) 
conn:on("receive", function(conn, payload) print(payload) end)
-- api.thingspeak.com 184.106.153.149
conn:connect(80,'184.106.153.149') 
conn:send("GET /update?key=Q67WTIRSOWGXJEO&field1="..t1.." HTTP/1.1\r\n") 
conn:send("Host: api.thingspeak.com\r\n") 
conn:send("Accept: */*\r\n") 
conn:send("User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n")
conn:send("\r\n")
conn:on("sent",function(conn)
                      print("Closing connection")
                      conn:close()
                  end)
conn:on("disconnection", function(conn)
          print("Got disconnection...")
  end)
end

-- send data every X ms to thing speak
tmr.alarm(0, 60000, 1, function() sendData() end )

--srv=net.createServer(net.TCP)
--srv:listen(port,
--     function(conn)
--          conn:send("HTTP/1.1 200 OK\nContent-Type: text/html\nRefresh: 5\n\n" ..
--              "<!DOCTYPE HTML>" ..
--              "<html><body>" ..
--              "<b>ESP8266</b></br>" ..
--              "Temperature : " .. ds18b20.read() .. "<br>" ..
--              "Node ChipID : " .. node.chipid() .. "<br>" ..
--              "Node MAC : " .. wifi.sta.getmac() .. "<br>" ..
--              "Node Heap : " .. node.heap() .. "<br>" ..
--              "Timer Ticks : " .. tmr.now() .. "<br>" ..
--              "</html></body>")          
--          conn:on("sent",function(conn) conn:close() end)
--     end
--
