SaucerMissile = class()

function SaucerMissile:init(pos)
    self.pos = pos
end

function SaucerMissile:collide(anObject)
    if anObject:is_a(Ship) then
        anObject:mutuallyDestroy(self)
    end
end

function SaucerMissile:killDist()
    return 0
end

function SaucerMissile:score()
end

function SaucerMissile:die()
    U:deleteObject(self)
end

function SaucerMissile:mutuallyDestroy(anObject)
    if anObject:is_a(Ship) then
        if self:inRange(anObject) then
            self:die()
            anObject:die()
        end
    end
end

function SaucerMissile:inRange(anObject)
    local triggerDistance = self:killDist() + anObject:killDist()
    local trueDistance = self.pos:dist(anObject.pos)
    return trueDistance < triggerDistance
end
