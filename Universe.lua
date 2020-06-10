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
    self.addedObjects = {}
    self.button = {}
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
    self:applyAdditions()
    self:adjustTimeValues(currentTime)
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

function Universe:adjustTimeValues(currentTime)
    self.currentTime = currentTime
    self.processorRatio = DeltaTime/0.0083333
    self.frame64 = (self.frame64+1)%64
end

function Universe:applyAdditions()
    for k,v in pairs(self.addedObjects) do
        self.objects[k] = v
    end
    self.addedObjects = {}
end

function Universe:checkBeat()
    if self.attractMode then return end
    self:updateBeatDelay()
    if self.currentTime - self.lastBeatTime > self.beatDelay then
        self.lastBeatTime = self.currentTime
        self:playBeat()
    end
end


function Universe:checkSaucer()
    if self.attractMode or Saucer:instance() then return end
    if self.currentTime - self.saucerTime > self.saucerInterval then
        self.saucerTime = self.currentTime
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
    self.addedObjects[object] = object
end

function Universe:deleteObject(object)
    self.objects[object] = nil
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
    for i = 1, 1 --[[self:newWaveSize()]] do
        if math.random(0,1) then
            pos = vec2(0,math.random(HEIGHT))
        else
            pos = vec2(math.random(WIDTH), 0)
        end
        Asteroid(pos)
    end
end

function Universe:findCollisions()
    for k, o in pairs(self.objects) do
        for kk, oo in pairs(self.objects) do
            o:collide(oo)
        end
    end
end

function Universe:findCollisionsXXX()
    for i,a in pairs(self.objects) do
        self:checkMissileCollisions(a)
        if Ship:instance() then self:checkShipCollision(a) end
    end
    if Ship:instance() then
        for i,m in pairs(self.objects) do
            self:checkMissileHitShip(m, Ship:instance())
        end
    end
end

function Universe:checkMissileHitShip(missile, ship)
    if not missile:is_a(Missile) then return end
    if not ship then return end
    if  missile.pos:dist(ship.pos) < ship:killDist() then
        ship:die()
        missile:die()
    end
end

function Universe:checkShipCollision(asteroid)
    if not asteroid:is_a(Asteroid) then return end
    if Ship:instance().pos:dist(asteroid.pos) < asteroid:killDist() then
        asteroid:score()
        asteroid:split()
        Ship:instance():die()
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

function Universe:mutualDestruction(p,q)
    local dist = p.pos:dist(q.pos)
    if dist < p:killDist() + q:killDist() then
        p:die()
        q:die()
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
