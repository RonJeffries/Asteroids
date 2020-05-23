-- Universe
-- RJ 20200523

Universe = class()

function Universe:init()
    self.asteroids = {}
end

function Universe:draw()
    drawAsteroids(self.asteroids)
end

function Universe:createAsteroids()
    createAsteroids(self.asteroids)
end

function Universe:findCollisions()
    for i,a in pairs(self.asteroids) do
        for k,m in pairs(Missiles) do
            if m.pos:dist(a.pos) < killDist(a) then
                scoreAsteroid(a)
                splitAsteroid(a, self.asteroids)
                m:die()
            end
        end
    end
end

