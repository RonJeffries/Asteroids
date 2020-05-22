-- Splat
-- RJ 20200521

local Splats = {}

local Vecs = {
vec2(-2,0), vec2(-2,-2), vec2(2,-2), vec2(3,1), vec2(2,-1), vec2(0,2), vec2(1,3), vec2(-1,3), vec2(-4,-1), vec2(-3,1)
}

function drawSplats()
    for k, splat in pairs(Splats) do
        splat:draw()
    end
end

Splat = class()

function Splat:init(pos)
    local die = function()
        Splats[self] = nil
    end
    self.pos = pos
    Splats[self] = self
    self.size = 2
    self.diameter = 6
    self.rot = math.random(0,359)
    tween(4, self, {size=10, diameter=1}, tween.easing.linear, die)
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
