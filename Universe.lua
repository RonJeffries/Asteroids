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
    self.objects = {}
    createButtons()
    Ship()
    self.waveSize = nil
    self.lastBeatTime = self.currentTime
    self:newWave()
end

function Universe:draw(currentTime)
    self:adjustTimeValues()
    --displayMode(FULLSCREEN_NO_BUTTONS)
    background(40, 40, 50)
    checkButtons()
    drawButtons()
    self:drawEverything()
    self:moveEverything()
    drawSplats()
    self:drawScore()
    self:findCollisions()
    self:checkBeat()
    self:checkSaucer()
    self:checkNewWave()
end

function Universe:adjustTimeValues()
    self.currentTime = currentTime
    self.processorRatio = DeltaTime/0.0083333
    self.frame64 = (self.frame64+1)%64
end

function Universe:checkSaucer()
    if self.attractMode or self.saucer then return end
    if self.currentTime - self.saucerTime > self.saucerInterval then
        self.saucerTime = currentTime
        Saucer()
    end
end

function Universe:drawEverything()
    for k,o in pairs(self.objects) do
        o:draw()
    end
end

function Universe:moveEverything()
    for k,o in pairs(self.objects) do
        o:move()
    end
end

function Universe:checkNewWave()
    local count = self:asteroidCount()
    if count == 0 then
        if self.timeOfNextWave == 0 then
            self.timeOfNextWave = self.currentTime + self.timeBetweenWaves
        end
    end
    if self.timeOfNextWave > 0 and self.currentTime >= self.timeOfNextWave then
        self:newWave()
    end
end

function Universe:asteroidCount()
    local c = 0
    for i,a in pairs(self.objects) do
        if a:is_a(Asteroid) then c = c + 1 end
    end
    return c
end

function Universe:addObject(object)
    self.objects[object] = object
end

function Universe:deleteObject(object)
    self.objects[object] = nil
end

function Universe:addExplosion(explosion)
    self.objects[explosion] = explosion
    self.explosions[explosion] = explosion
end

function Universe:deleteExplosion(explosion)
    self.objects[explosion] = nil
    self.explosions[explosion] = nil
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
    -- we clone the collection to allow live editing
    for i,a in pairs(clone(self.objects)) do
        self:checkMissileCollisions(a)
        if self.ship then self:checkShipCollision(a) end
    end
    if self.ship then
        for i,m in pairs(clone(self.objects)) do
            self:checkMissileHitShip(m, self.ship)
        end
    end
end

function Universe:checkMissileHitShip(missile, ship)
    if not missile:is_a(Missile) then return end
    if not ship then return end
    if  missile.pos:dist(ship.pos) < ship:killDist() then
        self:deleteShip(ship)
        missile:die()
    end
end

function Universe:checkShipCollision(asteroid)
    if not asteroid:is_a(Asteroid) then return end
    if self.ship.pos:dist(asteroid.pos) < asteroid:killDist() then
        asteroid:score()
        asteroid:split()
        self:deleteShip(self.ship)
    end
end

function Universe:checkMissileCollisions(asteroid)
    if not asteroid:is_a(Asteroid) then return end
    for k,m in pairs(self.objects) do
        if m:is_a(Missile) then
            if m.pos:dist(asteroid.pos) < asteroid:killDist() then
                asteroid:score()
                asteroid:split()
                m:die()
            end
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
    for k, missile in pairs(self.objects) do
        if missile:is_a(Missile) then missile:draw() end
    end
    for k, missile in pairs(self.objects) do
        if missile:is_a(Missile) then missile:move() end
    end
end

function Universe:drawAsteroids()
    for i,asteroid in pairs(self.objects) do
        if asteroid:is_a(Asteroid) then
            asteroid:draw()
            asteroid:move()
        end
    end
end

function Universe:drawScore()
    local s= "000000"..tostring(self.score)
    s = string.sub(s,-5)
    pushStyle()
    fontSize(100)
    text(s, 200, HEIGHT-60)
    popStyle()
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
