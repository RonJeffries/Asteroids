-- Ship
-- RJ 20200520

Ship = class(Destructible)

local Instance

function Ship:init(pos)
    self.pos = pos or vec2(WIDTH, HEIGHT)/2
    self.radians = 0
    self.step = vec2(0,0)
    self.scale = 2
    Instance = self
    U:addObject(self)
end

function Ship:instance()
    return Instance
end

local accel = 0

function Ship:draw()
    self:drawAt(self.pos, self.radians)
end

function Ship:drawAt(pos,radians)
    translate(pos.x, pos.y)
    rotate(math.deg(radians))
    strokeWidth(1)
    stroke(255)
    scale(self.scale or 2)
    self:drawLineShip()
end

function Ship:drawFancy()
    translate(self.pos.x, self.pos.y)
    rotate(math.deg(self.radians))
    rotate(-90)
    scale(0.5)
    sprite(asset.builtin.Space_Art.Red_Ship)
end

function Ship:drawLineShip()
    line(-3,-2, -3,2)
    line(-3,2, -5,4)
    line(-5,4, 7,0)
    line(7,0, -5,-4)
    line(-5,-4,-3,-2)
    accel = (accel+1)%3
    if U.button.go and accel == 0 then
        strokeWidth(1.5)
        line(-3,-2, -7,0)
        line(-7,0, -3,2)
    end
end

function Ship:move()
    if U.button.hyperspace then
        self:enterHyperspace()
    else
        if U.button.turn then self:turn() end
        if U.button.fire and not self.holdFire then self:fireMissile() end
        if not U.button.fire then self.holdFire = false end
        self:actualShipMove()
    end
end

function Ship:safeToAppear()
    for k,o in pairs(U.objects) do
        if self:inRange(o) then return false end
    end
    return true
end

function Ship:signalUnsafe()
    -- no signal implemented at this time
end

function Ship:enterHyperspace()
    U:deleteObject(self)
    self.pos = self:randomPointIn(100,200, WIDTH-100, HEIGHT-100)
    tween.delay(3,self.tryToAppear,self)
end

function Ship:tryToAppear()
    if self:safeToAppear() then
        U:addObject(self)
        self:dropIn()
    else
        self:signalUnsafe()
        tween.delay(3,self.tryToAppear,self)
    end
end

function Ship:dropIn()
    self.scale = 10
    tween(1, self, {scale=2})
end

function Ship:randomPointIn(x1, y1, x2, y2)
    local widthRange = x2 - x1
    local heightRange = y2 - y1
    local width = math.random(widthRange)
    local height = math.random(heightRange)
    return vec2(x1,y1) + vec2(width,height)
end

function Ship:score()
    return 0
end

function Ship:turn()
    local center = U.button.turnCenter
    local pos = U.button.turnPos
    self.radians = math.atan2(pos.y-center.y, pos.x-center.x)
end

function Ship:actualShipMove()
    if U.button.go then
        U:playStereo(U.sounds.thrust, self)
        local accel = vec2(0.015,0):rotate(self.radians)*U.processorRatio
        self.step = self.step + accel
        self.step = maximize(self.step, 6)
    else
        self.step = self.step*(0.995^U.processorRatio)
    end
    self:finallyMove()
end

function Ship:finallyMove()
    U:moveObject(self)
end

function maximize(vec, size)
    local s = vec:len()
    if s <= size then
        return vec
    else
        return vec*size/s
    end
end

function Ship:fireMissile()
    U:playStereo(U.sounds.fire, self)
    self.holdFire = true
    Missile:fromShip(self)
end

function Ship:killDist()
    return 12
end

function Ship:die()
    U:playStereo(U.sounds.bangLarge, self, 0.8)
    Explosion(self)
    U:deleteObject(self)
    Instance = nil
    if not U.attractMode then
        tween.delay(6, self.spawnUnlessAttractMode, self)
    end
end

function Ship:spawnUnlessAttractMode()
    if U.attractMode then return end
    Score:instance():spawnShip()
end