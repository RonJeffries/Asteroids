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
        --dump("in range", self, anObject)
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

function dump(msg, p,q)
    print(msg)
    dumpObj(p)
    dumpObj(q)
end

function dumpObj(o)
    print(kind(o), o, o.pos)
end

function kind(o)
    if o:is_a(Missile) then return "missile" end
    if o:is_a(Saucer) then return "saucer" end
    if o:is_a(Ship) then return "ship" end
    if o:is_a(Asteroid) then return "asteroid" end
    return "unknown"
end
