args = { ... }
if #args ~= 1 then
    print('Usage: update <path>')
else 
    shell.execute('delete', args[1])
    shell.execute('wget', 'http://localhost:8000/' .. args[1])
end