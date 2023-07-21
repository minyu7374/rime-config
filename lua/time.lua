--[[
time_translator: 将 `time` 翻译为当前时间
--]]

local function translator(input, seg)
   if (input == "time") then
      local formarts = {"%r", "%H:%M", "%H:%M:%S"} 
      for i = 1, #formarts do
        local cand = Candidate("time", seg.start, seg._end, os.date(formarts[i]), "")
        cand.quality = 1.1
        yield(cand)
      end
   end
end

return translator
