-- Explosion
-- RJ modified 20200612 indestructible
-- RJ modified 20200612 Fragments

Explosion = class()

function Explosion:init(ship)
    local pos = ship.pos
   for i = 1,5 do
       local f = Fragment(pos, i==1)
   end
end

-- Fragment
-- RJ 20200612 from Spacewar

Fragment = class()

function Fragment:init(pos, guy)
    self.pos = pos
    self.color = 255
    self.frag = not guy
    self.base = vec2(0,0)
    self.ang= math.random(360)
    self.step = vec2(2.0*math.random(),0):rotate(self.ang)
    self.spin = math.random(9)
    self.ds = 8*math.random()
    self.life = 4
    U:addIndestructible(self)
end

function Fragment:move()
    U:moveObject(self)
   self.spin = self.spin + self.ds
end

function Fragment:draw()
    self.life = self.life - DeltaTime
    if self.life < 0 then
        U:deleteIndestructible(self)
    end
    pushStyle()
    pushMatrix()
    stroke(self.color)
    strokeWidth(2)
    noFill()
    translate(self.pos.x, self.pos.y)
    rotate(self.spin)
    scale(1)
    if self.frag then
        line(-10,0,10,0)
        line(10,0,5,13)
    else
        scale(3)
        strokeWidth(1)
        ellipse(0,5,8)
        line(0,3,0,-2)
        line(-4,2,4,2)
        line(0,-2,-3,-5)
        line(0,-2,3,-5)
    end
    popMatrix()
    popStyle()
end