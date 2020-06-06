-- Universe
-- RJ 20200523

Universe = class()

local MissileSpeed = 2.0

function Universe:init()
    self.processorRatio = 1.0
    self.score = 0
    self.rotationStep = math.rad(1.5) -- degrees
    self.missileVelocity = vec2(MissileSpeed,0)
    self.frame64 = 0
    self.saucerInterval = 2
    self.timeBetweenWaves = 2
    self.timeOfNextWave= 0
    self:defineSounds()
    self.objects = {}
    self.button = {}
    self.asteroids = {}
    self.missiles = {}
    self.explosions = {}
    self.attractMode = true
end

function Universe:defineSounds()
    self.sounds = {}
    self.sounds.bangLarge = asset.bangLargeHi
    self.sounds.bangMedium = asset.bangMediumHi
    self.sounds.bangSmall = asset.bangSmallHi
    self.sounds.beat1 = asset.beat1
    self.sounds.beat2 = asset.beat2
    self.sounds.extraShip = asset.extraShipHi
    self.sounds.fire = asset.fire
    self.sounds.saucerBig = asset.saucerBigHi
    self.sounds.saucerSmall = asset.saucerSmallHi
    self.sounds.saucerFire = asset.saucerFireHi
    self.sounds.thrust = asset.thrust
end

function Universe:startGame(currentTime)
    self.currentTime = currentTime
    self.saucerTime = currentTime
    self.attractMode = false
    createButtons()
    Ship()
    self.asteroids = {}
    self.waveSize = nil
    self.lastBeatTime = self.currentTime
    self:newWave()
end

function Universe:draw(currentTime)
    self.currentTime = currentTime
    if self.timeOfNextWave > 0 and self.currentTime >= self.timeOfNextWave then
        self:newWave()
    end
    if not self.attractMode and not self.saucer and self.currentTime - self.saucerTime > self.saucerInterval then
        self.saucerTime = currentTime
        Saucer()
    end
    self.frame64 = (self.frame64+1)%64
    self:checkBeat()
    --displayMode(FULLSCREEN_NO_BUTTONS)
    pushStyle()
    background(40, 40, 50)
    self.processorRatio = DeltaTime/0.0083333
    self:drawAsteroids()
    self:drawExplosions()
    checkButtons()
    drawButtons()
    if self.ship then self.ship:draw() end
    if self.ship then self.ship:move() end
    if self.saucer then self.saucer:draw() end
    if self.saucer then self.saucer:move() end
    self:drawMissiles()
    drawSplats()
    self:drawScore()
    popStyle()
    self:findCollisions()
end

function Universe:asteroidCount()
    local c = 0
    for i,a in pairs(self.asteroids) do
        c = c + 1
    end
    return c
end

function Universe:addAsteroid(asteroid)
    self.objects[asteroid] = asteroid
    self.asteroids[asteroid] = asteroid
end

function Universe:deleteAsteroid(asteroid)
    self.objects[asteroid] = nil
    self.asteroids[asteroid] = nil
end

function Universe:addMissile(missile)
    self.objects[missile] = missile
    self.missiles[missile] = missile
end

function Universe:deleteMissile(missile)
    self.objects[missile] = nil
    self.missiles[missile] = nil
end

function Universe:addSaucer(saucer)
    self.objects[saucer] = saucer
    self.saucer = saucer
end

function Universe:deleteSaucer(saucer)
    self.objects[saucer] = nil
    self.saucer = nil
    self.saucerTime = self.currentTime
end

function Universe:addShip(ship)
    self.objects[ship] = ship
    self.ship = ship
end

function Universe:deleteShip(ship)
    local f = function()
        Ship()
    end
    Explosion(ship)
    self.objects[ship] = nil
    self.ship = nil
    tween(6, self, {}, tween.easing.linear, f)
end

function Universe:checkBeat()
    if self.attractMode then return end
    self:updateBeatDelay()
    if self.currentTime - self.lastBeatTime > self.beatDelay then
        self.lastBeatTime = self.currentTime
        self:playBeat()
    end
end

function Universe:updateBeatDelay()
    if self.frame64 == 63 and self.beatDelay > 0.128 then
        self.beatDelay = self.beatDelay - 0.016
    end
end

function Universe:playBeat()
    if self.lastBeat == self.sounds.beat2 then
        self.lastBeat = self.sounds.beat1
    else
        self.lastBeat = self.sounds.beat2
    end
    sound(self.lastBeat)
end

function Universe:newWave()
    local pos
    self.beatDelay = 1 -- second
    self.timeOfNextWave = 0
    for i = 1, self:newWaveSize() do
        if math.random(0,1) then
            pos = vec2(0,math.random(HEIGHT))
        else
            pos = vec2(math.random(WIDTH), 0)
        end
        Asteroid(pos)
    end
end

function Universe:findCollisions()
    -- we clone the asteroids collection to allow live editing
    local needNewWave = true
    for i,a in pairs(clone(self.asteroids)) do
        needNewWave = false
        self:checkMissileCollisions(a)
        if self.ship then self:checkShipCollision(a) end
    end
    if needNewWave == true then
        if self.timeOfNextWave == 0 then
            self.timeOfNextWave = self.currentTime + self.timeBetweenWaves
        end
    end
end

function Universe:checkShipCollision(asteroid)
    if self.ship.pos:dist(asteroid.pos) < asteroid:killDist() then
        asteroid:score()
        asteroid:split()
        self:deleteShip(self.ship)
    end
end

function Universe:checkMissileCollisions(asteroid)
    for k,m in pairs(self.missiles) do
        if self.ship and m.pos:dist(self.ship.pos) < self.ship:killDist() then
            self:deleteShip(self.ship)
            m:die()
        end
        if m.pos:dist(asteroid.pos) < asteroid:killDist() then
            asteroid:score()
            asteroid:split()
            m:die()
        end
    end
end

function Universe:moveObject(anObject)
    local pos = anObject.pos + self.processorRatio*anObject.step
    anObject.pos = vec2(pos.x%WIDTH, pos.y%HEIGHT)
end

function Universe:keepInBounds(value, bound)
    return (value+bound)%bound
end

function Universe:drawExplosions()
    for k,e in pairs(self.explosions) do
        e:draw()
    end
end

function Universe:drawMissiles()
    pushStyle()
    pushMatrix()
    fill(255)
    stroke(255)
    for k, missile in pairs(self.missiles) do
        missile:draw()
    end
    popMatrix()
    popStyle()
    for k, missile in pairs(self.missiles) do
        missile:move()
    end
end

function Universe:drawAsteroids()
    pushStyle()
    stroke(255)
    fill(0,0,0, 0)
    strokeWidth(2)
    rectMode(CENTER)
    for i,asteroid in pairs(self.asteroids) do
        asteroid:draw()
        asteroid:move()
    end
    popStyle()
end

function Universe:drawScore()
    local s= "000000"..tostring(self.score)
    s = string.sub(s,-5)
    fontSize(100)
    text(s, 200, HEIGHT-60)
end

function Universe:newWaveSize()
    self.waveSize = (self.waveSize or 2) + 2
    if  self.waveSize > 11 then self.waveSize = 11 end
    return self.waveSize
end

function Universe:adjustedRotationStep()
    return self.processorRatio*self.rotationStep
end

function Universe:playStereo(aSound, anObject)
    sound(aSound, 1, 1, 2*anObject.pos.x/WIDTH - 1)
end
