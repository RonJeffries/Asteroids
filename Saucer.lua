Saucer = class(Destructible)

local Instance;

function Saucer:init(optionalPos)
    function die()
        if self == Instance then
            self:dieQuietly()
        end
    end
    if Instance then assert(false, "instance") end
    Instance = self
    U:addObject(self)
    self.pos = optionalPos or vec2(0, math.random(HEIGHT))
    self.step = vec2(2,0)
    self.fireTime = U.currentTime + 1 -- one second from now
    if math.random(2) == 1 then self.step = -self.step end
    tween(7, self, {}, tween.easing.linear, die)
end

function Saucer:instance()
    return Instance
end

function Saucer:killDist()
    return 20
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
    U:moveObject(self)
    if U.currentTime >= self.fireTime then
        U:playStereo(U.sounds.saucerFire, self)
        self.fireTime = U.currentTime + 1
        Missile:fromSaucer(self)
    end
end

function Saucer:die()
    Splat(self.pos)
    self:dieQuietly()
end

function Saucer:dieQuietly()
    U:deleteObject(self)
    Instance = nil
    U.saucerTime = U.currentTime
end
