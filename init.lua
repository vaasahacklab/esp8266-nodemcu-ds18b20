print(wifi.sta.getip())
wifi.setmode(wifi.STATION)
wifi.sta.config("apname","password")

print(wifi.sta.getip())

dofile('dallas.lua')
