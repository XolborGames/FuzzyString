--!strict
local levenshtein = {}


--[[
    [Wikipedia: Levenshtein Distance](https://en.wikipedia.org/wiki/Levenshtein_distance)

    @param s the string to measure from
    @param t the string to measure to
    @return the amount of changes are needed to change `s` to `t`
]]
function levenshtein.raw(s: string, t: string): number
    -- switch s and t if s is longer than t
    if #s > #t then
        t,s = s,t
    end

    local m, n = #s, #t

    local v0, v1 = table.create(n + 1, 0), table.create(n + 1, 0)

    -- initialize v0 so that each value is its index (-1 because lua)
    -- so that it is the edit distance from an empty s to t
    for i,_ in v0 do
        v0[i] = i -1
    end


    for i = 1, m do
        v1[1] = i - 1

        for j = 1, n do
            local deletionCost = v0[j + 1] + 1
            local insertionCost = v1[j] + 1
            local substitutionCost = if s:sub(i, i) == t:sub(j, j)
                then v0[j]
                else v0[j] + 1

            v1[j + 1] = math.min(
                deletionCost,
                insertionCost,
                substitutionCost
            )
        end

        v0, v1 = v1, v0
    end

    return v0[n + 1]
end

--[[
    A weighted version of levenshtein so that the returned value is 0-1.

    @see levenshtein

    @param s the string to measure from
    @param t the string to measure to
    @return percentage of `s` that needs to change to convert it to `t` (0-1)
]]
function levenshtein.weighted(s: string, t: string): number
    return levenshtein.raw(s, t) / (#s + #t)
end


return levenshtein