local function select_block(block)
    for i=1, 16 do
        info = turtle.getItemDetail(i)
        if info and block == info['name'] then
            turtle.select(i)
            break
        end
    end
end

coal = 'minecraft:coal_block'

for i=1, 4 do 
    turtle.turnLeft()
end

select_block(coal)
turtle.refuel()

while true do
    turtle.digDown()
    turtle.down()
end