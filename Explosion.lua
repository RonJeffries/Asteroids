Explosion = class()

function Explosion:init(ship)
    local f = function()
        U.explosions[self] = nil
    end
    self.pos = ship.pos
    self.step = vec2(0,0)
    U.explosions[self] = self
    tween(4, self, {}, tween.easing.linear, f)
end

function Explosion:draw()
    pushStyle()
    pushMatrix()
    translate(self.pos.x, self.pos.y)
    fontSize(30)
    text("BLAMMO", 0, 0)
    popMatrix()
    popStyle()
end
