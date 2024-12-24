args = { ... }
turtle_count = tonumber(args[1]) 
assert(turtle_count ~= nil, 'provide the argument dumbass')

local function anykey(msg)
    str = ''
    if msg then 
        str = msg 
    else
        str = 'Press any key to continue...' 
    end
    print(str)
    os.pullEvent('key')
end

local function init()
    print('Connecting to rednet...')
    peripheral.find("modem", rednet.open)
    assert(rednet.isOpen(), 'rednet closed')
    print('Rednet open.') 
end

local function send_all(msg)
    print('Sending \'' .. msg .. '\' to all turtles...')
    for _, id in pairs(turtles) do
        rednet.send(id, msg)
        sleep(0.1)
    end
end

local function receive_connections() 
    turtles = {}
    _, line = term.getCursorPos()
    for i=1, turtle_count do 
        id, _ = rednet.receive()
        turtles[#turtles + 1] = id
        term.setCursorPos(1, line)
        write('Recieved: '.. i .. '/' .. turtle_count .. '            ')
        sleep(0.1)
    end
    for i=1, #turtles do
        print(turtles[i])
    end

    term.setCursorPos(1, line + 1)
    print('All turtles accounted for, sending continue...')
    sleep(0.1)
    send_all('continue')
    return turtles
end

local function receive_check() 
    check_passed = true 
    _, line = term.getCursorPos()
    for i=1, turtle_count do 
        _, msg = rednet.receive()
        term.setCursorPos(1, line)
        write('Recieved: '.. i .. '/' .. turtle_count .. '            ')
        if msg == 'bad' then
            check_passed = false
        end 
        sleep(0.1)
    end
    term.setCursorPos(1, line + 1)
    return check_passed
end

local function check(kind) 
    print('Recieving ' .. kind .. ' check from ' .. turtle_count .. ' turtles...')
    check_passed = receive_check()   
    sleep(0.1) 
    return_msg = ''
    if check_passed then 
        print('Check passed! continuing...')
        return_msg = 'continue'
    else
        print('Check failed! aborting...')
        return_msg = 'abort'
    end
    send_all(return_msg) --Resolve await_continue() 
end

init()

anykey('Awaiting final order.\nPress any key to begin.')
rednet.broadcast('begin')

-- Play music
local dfpwm = require("cc.audio.dfpwm")
local speaker = peripheral.find("speaker")

local decoder = dfpwm.make_decoder()

songs = {"song1.dfpwm", "disk/song2.dfpwm"}
inc = 0
for i=1, 2 do
    print('Starting song ' .. i) 
    inc = 0
    for chunk in io.lines(songs[i], 16 * 1024) do
        local buffer = decoder(chunk)
        inc = inc + 1
        print(inc)
        while not speaker.playAudio(buffer, 12) do
            os.pullEvent("speaker_audio_empty")
        end
    end
end