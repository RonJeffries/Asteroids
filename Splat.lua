-- Splat
-- RJ 20200521
-- moved to U.indestructibles 20200612

local Vecs = {
vec2(-2,0), vec2(-2,-2), vec2(2,-2), vec2(3,1), vec2(2,-1), vec2(0,2), vec2(1,3), vec2(-1,3), vec2(-4,-1), vec2(-3,1)
}

Splat = class()

function Splat:init(pos)
    self.pos = pos
    self.drawLevel = U.drawLevels.splat
    U:addIndestructible(self)
    self.size = 2
    self.diameter = 6
    self.rot = math.random(0,359)
    tween(4, self, {size=10, diameter=1}, tween.easing.linear, self.die, self)
end

function Splat:die()
    U:deleteIndestructible(self)
end

function Splat:draw()
    pushStyle()
    pushMatrix()
    translate(self.pos.x, self.pos.y)
    fill(255)
    stroke(255)
    rotate(self.rot)
    local s = self.size
    for i,v in ipairs(Vecs) do
        ellipse(s*v.x, s*v.y, self.diameter)
    end
    popMatrix()
    popStyle()
end

function Splat:move()
end
