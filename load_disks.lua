local function redstone_pulse(side)
    rs.setOutput(side, true)
    sleep(0.05)
    rs.setOutput(side, false)
end

args = { ... }
in_path = args[1]
out_path = './disk/startup.lua'
while true do
    redstone_pulse('left')
    os.pullEvent('disk')
    if fs.exists(out_path) then
        fs.delete(out_path)
    end
    fs.copy(in_path, out_path)
    redstone_pulse('back')
    sleep(0.2)
end