Saucer = class()

function Saucer:init()
    function die()
        self:die()
    end
    U:addSaucer(self)
    self.pos = vec2(0, math.random(HEIGHT))
    self.vel = vec2(2,0)
    if math.random(2) == 1 then self.vel = -self.vel end
    tween(7, self, {}, tween.easing.linear, die)
end

function Saucer:draw()
   pushMatrix()
   pushStyle()
   translate(self.pos.x%WIDTH, self.pos.y%HEIGHT)
   scale(4)
   stroke(255)
   strokeWidth(1)
   line(-2,1, 2,1)
   line(2,1, 5,-1)
   line(5,-1, -5,-1)
   line(-5,-1, -2,-3)
   line(-2,-3, 2,-3)
   line(2,-3, 5,-1)
   line(5,-1, 2,1)
   line(2,1, 1,3)
   line(1,3, -1,3)
   line(-1,3, -2,1)
   line(-2,1, -5,-1)
   popStyle()
   popMatrix()
end

function Saucer:move()
    self.pos = self.pos + self.vel
end

function Saucer:die()
    U:deleteSaucer()
end
