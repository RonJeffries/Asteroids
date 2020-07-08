-- Universe
-- RJ 20200523

Universe = class()

local MissileSpeed = 2.0

function Universe:init()
    self.processorRatio = 1.0
    self.rotationStep = math.rad(1.5) -- degrees
    self.missileVelocity = vec2(MissileSpeed,0)
    self.frame64 = 0
    self.freeShipPoints = 10000
    self.saucerInterval = 7
    self.timeBetweenWaves = 2
    self.timeOfNextWave= 0
    self:defineSounds()
    self:defineLevels()
    self.objects = {}
    self.indestructibles = {}
    self.addedObjects = {}
    self.button = {}
    self.attractMode = true
end

function Universe:defineLevels()
    self.t10 = {}
    self.t20 = {}
    self.t30 = {}
    self.t40 = {}
    self.t50 = {}
    self.t60 = {}
    self.t70 = {}
    self.t80 = {}
    self.t90 = {}
    self.drawLevels = {}
    self.drawLevels.backgound = t10
    self.drawLevels.ship = t20
    self.drawLevels.saucer = t30
    self.drawLevels.asteroid = t40
    self.drawLevels.missile = t50
    self.drawLevels.splat = t60
    self.drawLevels.fragment = t70
    self.drawLevels.score = t80
    self.drawLevels.buttons = t90
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
    self.indestructibles = {}
    self.waveSize = nil
    self.lastBeatTime = self.currentTime
    createButtons()
    Score(NumberOfShips):spawnShip()
    self:newWave()
end

function Universe:draw(currentTime)
    pushMatrix()
    pushStyle()
    self:applyAdditions()
    self:checkBeat()
    self:checkSaucer()
    self:checkNewWave()
    self:adjustTimeValues(currentTime)
    if FullScreen then
      displayMode(FULLSCREEN_NO_BUTTONS)
    end
    if not Fancy then background(40, 40, 50) end
    checkButtons()
    self:drawEverything()
    drawButtons()
    self:moveEverything()
    self:findCollisions()
    popStyle()
    popMatrix()
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
    for k,o in pairs(self.indestructibles) do
        self:drawProperly(o)
    end
    for k,o in pairs(self.objects) do
        self:drawProperly(o)
    end
end

function Universe:drawProperly(anObject)
    pushMatrix()
    pushStyle()
    if Fancy and anObject.drawFancy then
        anObject:drawFancy()
    else
        anObject:draw()
    end
    popStyle()
    popMatrix()
end

function Universe:moveEverything()
    for k,o in pairs(self.objects) do
        o:move()
    end
    for k,o in pairs(self.indestructibles) do
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

function Universe:addIndestructible(object)
    self.indestructibles[object] = object
end

function Universe:deleteIndestructible(object)
    self.indestructibles[object] = nil
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
    for k, o in pairs(self.objects) do
        for kk, oo in pairs(self.objects) do
            if self.objects[o] then o:collide(oo) end
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

function Universe:newWaveSize()
    self.waveSize = (self.waveSize or 2) + 2
    if  self.waveSize > 10 then self.waveSize = 10 end
    return self.waveSize
end

function Universe:adjustedRotationStep()
    return self.processorRatio*self.rotationStep
end

function Universe:playStereo(aSound, anObject, optionalPitch)
    sound(aSound, 1, optionalPitch or 1, 2*anObject.pos.x/WIDTH - 1)
end
