Destructible = class()

function Destructible:init(x)
    assert(false) -- no one should make one of these
end

function Destructible:collide(anObject)
    if self:unrelated(anObject) then
        anObject:mutuallyDestroy(self)
    end
end

function Destructible:mutuallyDestroy(anObject)
    if self:inRange(anObject) then
        self:die()
        anObject:die()
    end
end

function Destructible:inRange(anObject)
    local triggerDistance = self:killDist() + anObject:killDist()
    local trueDistance = self.pos:dist(anObject.pos)
    return trueDistance < triggerDistance
end

function Destructible:unrelated(anObject)
    return getmetatable(self) ~= getmetatable(anObject)
end
