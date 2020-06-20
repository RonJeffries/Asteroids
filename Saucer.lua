Saucer = class(Destructible)

local Instance;

function Saucer:init(optionalPos)
    function die()
        if self == Instance then
            self:dieQuietly()
        end
    end
    Instance = self
    U:addObject(self)
    if Score:instance():shouldDrawSmallSaucer() then
        self.size = 0.5
        self.sound = sound(asset.saucerSmallHi, 0.8, 1, 0, true)
    else
        self.size = 1
        self.sound = sound(asset.saucerBigHi, 0.8, 1, 0, true)
    end
    self.shotSpeed = 3
    self.pos = optionalPos or vec2(0, math.random(HEIGHT))
    self.step = vec2(2,0)
    self.fireTime = U.currentTime + 1 -- one second from now
    if math.random(2) == 1 then self.step = -self.step end
    self:setRandomTurnTime()
    tween.delay(7, die)
end

function Saucer:setRandomTurnTime()
    self.turnTime = ElapsedTime + 0.5 + math.random()
end

function Saucer:randomTurn()
    local x = self.step.x > 0 and 1 or -1
    local y = math.random(-1,1)
    self.step = vec2(x, y):normalize()*2
    self:setRandomTurnTime()
end

function Saucer:instance()
    return Instance
end

function Saucer:killDist()
    return 20*self.size
end

function Saucer:draw()
   pushMatrix()
   pushStyle()
   translate(self.pos.x%WIDTH, self.pos.y%HEIGHT)
   scale(4*self.size)
   stroke(255)
   strokeWidth(1)
   line(-2,1, 2,1)
   line(2,1, 5,-1)
   line(5,-1, -5,-1)
   line(-5,-1, -2,-3)
   line(-2,-3, 2,-3)
   line(2,-3, 5,-1)
   line(5,-1, 2,1)
   line(2,1, 1,3)
   line(1,3, -1,3)
   line(-1,3, -2,1)
   line(-2,1, -5,-1)
   popStyle()
   popMatrix()
end

function Saucer:move()
    if self.turnTime < ElapsedTime then
        self:randomTurn()
    end
    U:moveObject(self)
    if U.currentTime >= self.fireTime then
        U:playStereo(U.sounds.saucerFire, self)
        self.fireTime = U.currentTime + 0.5
        SaucerMissile:fromSaucer(self)
    end
end

function SaucerMissile:randomFromSaucer(saucer)
    local rot = math.random()*2*math.pi
    local pos = saucer.pos + vec2(saucer:killDist() + 1, 0):rotate(rot)
    local vel = U.missileVelocity:rotate(rot) + saucer.step
    return SaucerMissile(pos, vel)
end

function SaucerMissile:fromSaucer(saucer)
    if not Ship:instance() or math.random() > saucer:accuracyFraction() then 
        return SaucerMissile:randomFromSaucer(saucer) 
    end
    local targ = Targeter(saucer, Ship:instance())
    local dir = targ:fireDirection()
    bulletStep = dir*saucer.shotSpeed + saucer.step
    return SaucerMissile(saucer.pos, bulletStep)
end

function Saucer:accuracyFraction()
    return self.size == 1 and 1/20 or 4/20
end

function Saucer:die()
    Splat(self.pos)
    self:dieQuietly()
end

function Saucer:dieQuietly()
    self.sound:stop()
    U:deleteObject(self)
    Instance = nil
    U.saucerTime = U.currentTime
end

function Saucer:score(anObject)
    if anObject:is_a(Missile) then
        return self.size == 1 and 250 or 1000
    else
        return 0
    end
end
