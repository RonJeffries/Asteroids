-- Ship
-- RJ 20200520

Ship = class()

function Ship:init()
    self.pos = vec2(WIDTH, HEIGHT)/2
    self.radians = 0
    self.step = vec2(0,0)
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
    if U.button.left then self.radians = self.radians + U:adjustedRotationStep() end
    if U.button.right then self.radians = self.radians - U:adjustedRotationStep() end
    if U.button.fire then if not self.holdFire then self:fireMissile() end end
    if not U.button.fire then self.holdFire = false end
    self:actualShipMove()
end

function Ship:actualShipMove()
    if U.button.go then
        sound(U.sounds.thrust)
        local accel = vec2(0.015,0):rotate(self.radians)
        self.step = self.step + accel
        self.step = maximize(self.step, 3)
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
    sound(U.sounds.fire)
    self.holdFire = true
    Missile(self)
end
