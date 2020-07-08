-- Explosion
-- RJ modified 20200612 indestructible
-- RJ modified 20200612 Fragments

Explosion = class()

function Explosion:init(ship)
    local pos = ship.pos
   for i = 1,5 do
       local f = Fragment(pos, i)
   end
end

-- Fragment
-- RJ 20200612 from Spacewar

Fragment = class()

function Fragment:init(pos, frag)
    self.pos = pos
    self.color = 255
    self.frag = frag
    self.base = vec2(0,0)
    self.ang= math.random(360)
    self.step = vec2(2.0*math.random(),0):rotate(self.ang)
    self.spin = math.random(9)
    self.ds = 8*math.random()
    self.life = 4
    U:addIndestructible(self, U.drawLevels.fragment)
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
    stroke(self.color)
    strokeWidth(2)
    noFill()
    translate(self.pos.x, self.pos.y)
    rotate(self.spin)
    scale(1)
    zLevel(1)
    if self.frag ~= 1 then
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
end


local FragArt = {asset.builtin.Space_Art.Part_Red_Hull_2,
asset.builtin.Space_Art.Part_Red_Wing_1,
asset.builtin.Space_Art.Part_Red_Wing_2,
asset.builtin.Space_Art.Part_Red_Hull_3,
asset.builtin.Space_Art.Part_Red_Wing_4,}

function Fragment:drawFancy()
    self.life = self.life - DeltaTime
    if self.life < 0 then
        U:deleteIndestructible(self)
    end
    translate(self.pos.x, self.pos.y)
    scale(0.33)
    rotate(self.spin)
    zLevel(1)
    sprite(FragArt[self.frag])
end