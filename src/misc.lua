--!strict
local misc = {}

-- local libs, to avoid circular dependencies
local libs = {
    damerau = require(script.Parent.damerauLevenshtein)
}


--[[
    Counts the amount of times `string:find()` finds `s` in `t`.

    **Important**: it finds `s` in `t`, so it is important that you use the correct order.
    **Note**: it includes overlap in the count.

    @param t the string to call `:find()` on
    @param s the string to find in `t`

    @return the amount of times `s` appears in `t`
]]
function misc.findCount(t: string, s: string): number
    local count = 0
    local lastMatchIndex = 1

    while lastMatchIndex < #t do
        local hit = t:find(s, lastMatchIndex)

        if not hit or hit < 1 then
            break
        end

        lastMatchIndex = hit + 1 -- ignore TypeError, roblox's typechecker needs improvements
        count += 1
    end

    return count
end

--[[
    A combination of damerau levenshtein and `string.find()`,
    to order items closer to what the user would expect.

    **Important**: it finds `s` in `t`, so it is important that you use the correct order.

    @param s the string to search for
    @param t the string to search

    @return the amount of changes are needed to change `s` to `t`, subtracted by the amount of matches divided by 4
]]
function misc.damerauFind(s: string, t: string): number
    local matchPerc = libs.damerau.weighted(s, t)
    local count = misc.findCount(t, s)

    return matchPerc - count/4
end


return misc