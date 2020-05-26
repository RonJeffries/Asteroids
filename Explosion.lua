Explosion = class()

function Explosion:init(ship)
    self.pos = ship.pos
    self.step = vec2(0,0)
    U.explosions[self] = self
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
