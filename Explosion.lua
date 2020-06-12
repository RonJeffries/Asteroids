-- Explosion
-- RJ modified 20200612 indestructible
-- RJ modified 20200612 Fragments

Explosion = class()

function Explosion:init(ship)
    local pos = ship.pos
   for i = 1,5 do
       local f = Fragment(pos, i==1)
   end
end
