SaucerMissile = class()

function SaucerMissile:init(pos, step)
    function die()
        self:die()
    end
    self.pos = pos
    self.step = step 
    U:addObject(self)
    tween(3, self, {}, tween.easing.linear, die)
end

function SaucerMissile:draw()
    pushStyle()
    pushMatrix()
    fill(255)
    stroke(255)
    ellipse(self.pos.x, self.pos.y, 6)
    popMatrix()
    popStyle()
end

function SaucerMissile:move()
    U:moveObject(self)
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
