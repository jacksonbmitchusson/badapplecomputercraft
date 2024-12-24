local function await_confirmation()
    print('Awaiting confirmation...')
    id, msg = rednet.receive()
    if msg == 'abort' then 
        os.reboot()
    end
    print('Confirmation recieved.')
end

local function redstone_pulse(side)
    rs.setOutput(side, true)
    sleep(0.05)
    rs.setOutput(side, false)
end

await_confirmation() 

while true do 
    redstone_pulse('back')
    sleep(10)
end