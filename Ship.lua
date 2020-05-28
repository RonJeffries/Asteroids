-- Ship
-- RJ 20200520

Ship = class()

function Ship:init()
    self.pos = vec2(WIDTH, HEIGHT)/2
    self.radians = 0
    self.step = vec2(0,0)
end

function Ship:draw()
    local sx = 10
    local sy = 6
    pushStyle()
    pushMatrix()
    translate(self.pos.x, self.pos.y)
    rotate(math.deg(self.radians))
    strokeWidth(2)
    stroke(255)
    line(sx,0, -sx,sy)
    line(-sx,sy, -sx,-sy)
    line(-sx,-sy, sx,0)
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
    self.holdFire = true
    Missile(self)
end
