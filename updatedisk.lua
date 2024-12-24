drive = peripheral.find('drive')
if drive.isDiskPresent() then 
    shell.run('update', 'execplanrobot.lua')
    print('updated execplanrobot.')
    if fs.exists('disk/startup.lua') then
        fs.delete('disk/startup.lua')
    end
    print('deleted old version from disk')
    fs.copy('execplanrobot.lua', 'disk/startup.lua')
    print('copied new version to disk')
end