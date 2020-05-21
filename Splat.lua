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
    self.pos = pos
    Splats[self] = self
    self.size = 1
end

function Splat:draw()
    pushStyle()
    pushMatrix()
    translate(self.pos.x, self.pos.y)
    fill(255)
    scale(2)
    local s = self.size
    for i,v in ipairs(Vecs) do
        ellipse(s*v.x, s*v.y, 2)
    end
    popMatrix()
    popStyle()
    self.size = self.size * (1 + DeltaTime)
    if self.size > 5 then Splats[self] = nil end
end
