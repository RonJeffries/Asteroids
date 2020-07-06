-- Missile
-- RJ 20200522

Missile = class(Destructible)

function Missile:init(pos, step)
    self.pos = pos
    self.step = step 
    U:addObject(self)
    tween.delay(3, self.die, self)
end

function Missile:fromShip(ship)
    local pos = ship.pos + vec2(ship:killDist() + 1,0):rotate(ship.radians)
    local step = U.missileVelocity:rotate(ship.radians) + ship.step
    return Missile(pos, step)
end

function Missile:die()
    U:deleteObject(self)
end

function Missile:score()
    return 0
end

function Missile:draw()
    fill(255)
    stroke(255)
    ellipse(self.pos.x, self.pos.y, 6)
end

function Missile:drawFancy()
    translate(self.pos.x, self.pos.y)
    scale(0.5)
    sprite(asset.builtin.Space_Art.Red_Explosion)
end

function Missile:move()
    U:moveObject(self)
end

function Missile:killDist()
    return 0
end

-- SaucerMissile
SaucerMissile = class(Missile)

function SaucerMissile:randomFromSaucer(saucer)
    local rot = math.random()*2*math.pi
    local pos = saucer.pos + vec2(saucer:killDist() + 1, 0):rotate(rot)
    local vel = U.missileVelocity:rotate(rot) + saucer.step
    return SaucerMissile(pos, vel)
end
    
function SaucerMissile:aimedFromSaucer(saucer, ship)
    local gunPos = saucer.pos
    local tgtPos = ship.pos + ship.step*120
    local toTarget = tgtPos - gunPos
    local ang = vec2(1,0):angleBetween(toTarget)
    local bulletStep = vec2(saucer.shotSpeed, 0):rotate(ang)
    return SaucerMissile(gunPos, bulletStep)
end

function SaucerMissile:collide(anObject)
    if anObject:is_a(Ship) then
        anObject:mutuallyDestroy(self)
    end
end

function SaucerMissile:drawFancy()
    translate(self.pos.x, self.pos.y)
    scale(0.5)
    sprite(asset.builtin.Space_Art.Green_Explosion)
end

function SaucerMissile:mutuallyDestroy(anObject)
    if anObject:is_a(Ship) then
        if self:inRange(anObject) then
            self:die()
            anObject:die()
        end
    end
end
