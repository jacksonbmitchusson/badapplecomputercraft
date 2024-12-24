local function turnAround()
    turtle.turnRight()
    turtle.turnRight()
end

-- options are "left", "right", and "around"
local function turn(dir)
    choices = {['left']=turtle.turnLeft, ['right']=turtle.turnRight, ['around']=turnAround}
    choices[dir]()
end

local function move(dir, amt)
    amount = amt or 1
    choices = {['up']=turtle.up, ['forward']=turtle.forward, ['back']=turtle.back, ['down']=turtle.down}
    for i=1, amount do 
        choices[dir]()
    end
end

local function select_block(block)
    for i=1, 16 do
        info = turtle.getItemDetail(i)
        if info and block == info['name'] then
            turtle.select(i)
            break
        end
    end
end

local function place_block(block) 
    select_block(block)
    turtle.place()
end

local function moveplace(dir, block, amt)
    amount = amt or 1
    for i=1, amount do 
        move(dir)
        place_block(block)        
    end
end

local function deposit(item, amt)
    select_block(item)
    turtle.drop(amt)
end 

args = { ... }
size = tonumber(args[1])

coal = 'minecraft:coal_block'

-- turtle to be placed in the front right corner of the chunk, facing forward
turtle.select(1)
info = turtle.getItemDetail(i)
assert(info ~= nil, 'stupid')
block = info['name']

for i=1, size do
    move('forward', size)
    for i=1, size do
        moveplace('back', block)
        deposit(coal, 1)
        peripheral.call('front', 'turnOn')
    end
    turn('left')
    move('forward')
    turn('right')
end