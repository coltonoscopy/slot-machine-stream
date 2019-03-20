Timer = require 'lib/knife.timer'

gIcons = {'50', 'apple', 'banana', 'cherry', 'lemon', 'orange',
    'pineapple', 'strawberry'}

gTextures = {
    ['slot-machine'] = love.graphics.newImage('graphics/slot-machine.png'),
    ['casino'] = love.graphics.newImage('graphics/casino.jpg')
}

for k, v in pairs(gIcons) do
    gTextures[v] = love.graphics.newImage('graphics/' .. v .. '.jpg')
end