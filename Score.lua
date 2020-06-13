Score = class()

local Instance = nil

function Score:init()
    self.totalScore = 0
    Instance = self
end

function Score:instance()
    return Instance
end

function Score:addScore(aNumber)
    self.totalScore = self.totalScore + aNumber
end

function Score:score()
    return self.totalScore
end

function Score:draw()
end

