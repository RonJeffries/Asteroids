Saucer = class()

local Instance;

function Saucer:init()
    function die()
        self:die()
    end
    Instance = self
    U:addObject(self)
    self.pos = vec2(0, math.random(HEIGHT))
    self.step = vec2(2,0)
    self.fireTime = U.currentTime + 1 -- one second from now
    if math.random(2) == 1 then self.step = -self.step end
    tween(7, self, {}, tween.easing.linear, die)
end

function Saucer:instance()
    return Instance;
end

function Saucer:draw()
   pushMatrix()
   pushStyle()
   translate(self.pos.x%WIDTH, self.pos.y%HEIGHT)
   scale(4)
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
    self.pos = self.pos + self.step
    if U.currentTime >= self.fireTime then
        self.fireTime = U.currentTime + 1
        Missile:fromSaucer(self)
    end
end

function Saucer:die()
    U:deleteObject(self)
    Instance = nil
    U.saucerTime = U.currentTime
end

function Saucer:collide(anObject)
    anObject:collideWithSaucer(self)
end

function Saucer:collideWithMissile(missile)
    U:destroy(self)
    U:destroy(missile)
end
