local function copy_startup() 
    if fs.exists('disk/startup.lua') then
        if fs.exists('./startup.lua') then
            fs.delete('./startup.lua') 
        end
        fs.copy('disk/startup.lua', './startup.lua')
    end    
end

local function select(target_name)
    for i=1, 16 do 
        item = turtle.getItemDetail(i)
        if item and item['name'] == target_name then 
            turtle.select(i)
            break
        end
    end
end

local function placedown() 
    -- Destroy pipe above 
    turtle.up()
    turtle.digUp()
    while true do
        select('projecte:red_matter_block')
        turtle.placeDown()
        turtle.up()
    end
end

local function refuel() 
    select('minecraft:coal_block')
    turtle.refuel()
    print('Refueled.')
end

local function count_item(target_name) 
    count = 0
    for i=1, 16 do
        item = turtle.getItemDetail(i)
        if item and item['name'] == target_name then
            count = count + item['count']    
        end
    end
    print(count)
    return count 
end

local function accept_payload()
    turtle.digUp() -- Destroy drive above turtle
    turtle.up() 
    while count_item('projecte:red_matter_block') < 400 do sleep(0.05) end
    turtle.down()
end

local function init()
    for i=1, 4 do 
        turtle.turnLeft()
    end
    refuel()
    peripheral.find("modem", rednet.open)
    assert(rednet.isOpen(), 'rednet closed')
    print('Rednet open.')
end

local function await_confirmation()
    print('Awaiting confirmation...')
    id, msg = rednet.receive()
    if msg == 'abort' then 
        os.reboot()
    end
    print('Confirmation recieved.')
end

local function check(good, kind)
    out_msg = ''
    if good then 
        out_msg = 'good'
    else
        out_msg = 'bad'
    end
    print('Sending \'' .. out_msg .. '\' for ' .. kind .. ' check')
    rednet.send(master_id, out_msg)
    await_continue()
end

local function connection_check() 
    print('Waiting for master connection')
    master_id, _ = rednet.receive('turtle_connection')
    print('Received, master_id: ' .. master_id)
    rednet.send(master_id, 'connection_response')
    await_continue()
    return master_id
end

-- initialize robot
init()

-- get blocks 
accept_payload()

-- Receive signal to begin construction
await_confirmation() 

-- Begin construction 
placedown()