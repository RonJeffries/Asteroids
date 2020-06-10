Destructible = class()

function Destructible:init(x)
    assert(false) -- no one should make one of these
end

function Destructible:collide(anObject)
    print("collide", self, anObject)
    anObject:mutuallyDestroy(self)
end

function Destructible:mutuallyDestroy(anObject)
    print("mutuallyDestroy", self, anObject)
    if self:inRange(anObject) then
        print("in range")
        self:die()
        anObject:die()
    end
end

function Destructible:inRange(anObject)
    local triggerDistance = self:killDist() + anObject:killDist()
    local trueDistance = self.pos:dist(anObject.pos)
    print(triggerDistance, trueDistance)
    print(self.pos, anObject.pos)
    return trueDistance < triggerDistance
end
