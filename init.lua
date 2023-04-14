--!strict
local module = {}

--[[
    [Wikipedia: Levenshtein Distance](https://en.wikipedia.org/wiki/Levenshtein_distance)

    @param s the string to measure from
    @param t the string to measure to
    @return the amount of changes are needed to change `s` to `t`
]]
function module.levenshtein(s: string, t: string): number
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
function module.weightedLevenshtein(s: string, t: string): number
    return module.levenshtein(s, t) / (#s + #t)
end


--[[
    [Wikipedia: Damerau Levenshtein Distance](https://en.wikipedia.org/wiki/Damerau%E2%80%93Levenshtein_distance)

    @param s the string to measure from
    @param t the string to measure to
    @return the amount of changes are needed to change `s` to `t`
]]
function module.damerauLevenshtein(s: string, t: string): number
    -- switch s and t if s is longer than t
    if #s > #t then
        t,s = s,t
    end

    local m, n = #s, #t

    local vn, v0, v1 = table.create(n + 1, 0), table.create(n + 1, 0), table.create(n + 1, 0)

    -- initialize v0 so that each value is its index (-1 because lua)
    -- so that it is the edit distance from an empty s to t
    for i,_ in v0 do
        v0[i] = i -1
    end


    for i = 1, m do
        v1[1] = i-1

        for j = 1, n do
            local cost = if s:sub(i, i) == t:sub(j, j) then 0 else 1

            -- check whether this and previous character can be switched
            if i > 2 and j > 2 and s:sub(i, i) == t:sub(j-1, j-1) and s:sub(i-1, i-1) == t:sub(j, j) then
                local noChangeCost = v1[j + 1]
                local transpositionCost = vn[j - 1] + 1

                v1[j + 1] = math.min(
                    noChangeCost,
                    transpositionCost
                )
            else
                local deletionCost = v0[j + 1] + 1
                local insertionCost = v1[j] + 1
                local substitutionCost = v0[j] + cost

                v1[j + 1] = math.min(
                    deletionCost,
                    insertionCost,
                    substitutionCost
                )
            end
        end

        -- shift all arrays up by one
        vn, v0, v1 = v0, v1, vn
    end

    return v0[n + 1];
end

--[[
    A weighted version of damerau levenshtein so that the returned value is 0-1.

    @see damerauLevenshtein

    @param s the string to measure from
    @param t the string to measure to
    @return percentage of `s` that needs to change to convert it to `t` (0-1)
]]
function module.weightedDamerauLevenshtein(s: string, t: string): number
    return module.damerauLevenshtein(s, t) / (#s + #t)
end

return module