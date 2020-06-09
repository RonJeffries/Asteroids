-- Asteroid
-- RJ 20200520

local DeadAsteroids = {}
local Vel = 1.5

Asteroid = class()

function Asteroid:init(pos, size)
    self.pos = pos or vec2(math.random(WIDTH), math.random(HEIGHT))
    self.scale = size or 16
    self.shape = Rocks[math.random(1,4)]
    local angle = math.random()*2*math.pi
    self.step = vec2(Vel,0):rotate(angle)
    U:addObject(self)
end

function Asteroid:killDist()
    local s = self.scale
    if s == 16 then return 64 elseif s == 8 then return 32 else return 16 end
end

function Asteroid:score()
    local s = self.scale
    local inc = 0
    if s == 16 then inc = 20
    elseif s == 8 then inc = 50
    else inc = 100
    end
    U.score = U.score + inc
end

function Asteroid:bang()
    if not U.sounds then return end
    if self.scale == 16 then
        U:playStereo(U.sounds.bangLarge, self)
    elseif self.scale == 8 then
        U:playStereo(U.sounds.bangMedium, self)
    elseif self.scale == 4 then
        U:playStereo(U.sounds.bangSmall, self)
    end
end

function Asteroid:split()
    self:bang()
    Splat(self.pos)
    if self.scale ~= 4 then
        Asteroid(self.pos, self.scale//2)
        Asteroid(self.pos, self.scale//2)
    end
    U:deleteObject(self)
end

function Asteroid:die()
    self:bang()
    Splat(self.pos)
    if self.scale ~= 4 then
        Asteroid(self.pos, self.scale//2)
        Asteroid(self.pos, self.scale//2)
    end
    U:deleteObject(self)
end

function Asteroid:draw()
    pushMatrix()
    pushStyle()
    stroke(255)
    fill(0,0,0, 0)
    strokeWidth(2)
    rectMode(CENTER)
    translate(self.pos.x, self.pos.y)
    scale(self.scale)
    strokeWidth(1/self.scale)
    for i,l in ipairs(self.shape) do
        line(l.x, l.y, l.z, l.w)
    end
    popStyle()
    popMatrix()
end

function Asteroid:move()
    U:moveObject(self)
end

function Asteroid:collideWithMissile(o)
    U:mutualDestruction(self,o)
end

