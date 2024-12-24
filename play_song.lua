local vol = { ... }

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
