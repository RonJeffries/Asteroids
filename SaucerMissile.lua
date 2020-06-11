SaucerMissile = class(Missile)

function SaucerMissile:collide(anObject)
    if anObject:is_a(Ship) then
        anObject:mutuallyDestroy(self)
    end
end

function SaucerMissile:mutuallyDestroy(anObject)
    if anObject:is_a(Ship) then
        if self:inRange(anObject) then
            self:die()
            anObject:die()
        end
    end
end
