local function in_chunk(rx, ry, rz)
    x = -442 + rx
    y = -60  + ry
    z = -872 + rz
    return (x >= -448 and x <= -433) and (y >= -70 and y <= -61)  and (z >= -880 and z <= -865)
end

local function trim_scan(blocks) 
    new_blocks = {}
    new_idx = 1
    for _, block in pairs(blocks) do
        x = block['x']
        y = block['y']
        z = block['z']
        if in_chunk(x, y, z) then 
            new_blocks[new_idx] = block
            new_idx = new_idx + 1
        end
    end
    return new_blocks
end

local function tally_blocks(blocks)
    tally = {}
    for _, block in pairs(blocks) do 
        name = block['name']
        if tally[name] ~= nil then 
            tally[name] = tally[name] + 1    
        else 
            tally[name] = 1
        end
    end
    return tally
end

local scanner = peripheral.wrap('left')

print('scanning...')
local blocks = scanner.scan(16)
print('done, found ' .. #blocks .. ' blocks.')

print('trimming scan...')
local new_blocks = trim_scan(blocks)
print('done, reduced to ' .. #new_blocks .. ' blocks.')

print('tallying blocks')
local tally = tally_blocks(new_blocks)
print('done')

for name, amt in pairs(tally) do
    print(name .. ': ' .. amt)
end 