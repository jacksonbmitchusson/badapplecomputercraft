args = { ... }

function dec(data)
    data = data:gsub('[^'..b..'=]', '')  -- Remove invalid characters
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,b='',b:find(x)-1
        for i=6,1,-1 do r=r..(b % 2^i - b % 2^(i-1) > 0 and '1' or '0') end
        return r
    end):gsub('%d%d%d%d%d%d%d%d', function(x)
        return string.char(tonumber(x, 2))
    end))
end

b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
url = 'https://api.github.com/repos/jacksonbmitchusson/badapplecomputercraft/contents/' .. args[1] .. '?ref=main'
req = http.get(url)
response = req.readAll()
req.close()
response = textutils.unserializeJSON(response)
--encoded_clean = encoded:gsub('%s+', '')
decoded = dec(response['content'])
file = fs.open(args[1], 'w+')
file.write(decoded)
file.close()