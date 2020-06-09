-- Ship
-- RJ 20200520

Ship = class()

local Instance

function Ship:init()
    self.pos = vec2(WIDTH, HEIGHT)/2
    self.radians = 0
    self.step = vec2(0,0)
    Instance = self
    U:addObject(self)
end

function Ship:instance()
    return Instance
end

local accel = 0

function Ship:draw()
   local sx = 10
   local sy = 6
   pushStyle()
   pushMatrix()
   translate(self.pos.x, self.pos.y)
   rotate(math.deg(self.radians))
   strokeWidth(1)
   stroke(255)
   scale(2)
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
   popMatrix()
   popStyle()
end

function Ship:move()
    if U.button.turn then self:turn() end
    if U.button.fire and not self.holdFire then self:fireMissile() end
    if not U.button.fire then self.holdFire = false end
    self:actualShipMove()
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
    return 24
end

function Ship:die()
    local f = function()
        Ship()
    end
    Explosion(self)
    U:deleteObject(self)
    Instance = nil
    tween(6, self, {}, tween.easing.linear, f)
end
