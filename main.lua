--[[
    Slot Machine Game
    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

require 'constants'
require 'Dependencies'

local slotPadding = (WINDOW_WIDTH - gTextures['slot-machine']:getWidth()) / 2

local slotReels = {{}, {}, {}}

-- local slotIcons = {'apple', '50', 'lemon', 'orange', 'pineapple', 'cherry',
--     'strawberry', 'banana'}

local slotIcons = {'apple', '50', '50', '50', 'apple', 'apple'}

local slotVelocities = {0, 0, 0}

local stops = {
    { target = 0, total = 0 },
    { target = 0, total = 0 },
    { target = 0, total = 0 }
}

local running = false
local win = false

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    love.window.setTitle('Slot50')

    math.randomseed(os.time())

    -- populate each slot reel with icons
    for i = 1, 3 do

        -- generate entire slot reel for this column
        for k, v in pairs(slotIcons) do
            table.insert(slotReels[i], {
                icon = v,
                x = slotPadding + HORIZONTAL_SLOT_OFFSET + (SLOT_ICON_OFFSET * (i - 1)),
                y = VERTICAL_SLOT_OFFSET + (k - 1) * ICON_SIZE
            })
        end
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'space' then
        
        -- set velocity of reels
        if slotVelocities[1] == 0 and not running then
            running = true
            win = false

            Timer.tween(2, {
                [slotVelocities] = {[1] = 500}
            })

            Timer.after(0.1, function()
                Timer.tween(2, {
                    [slotVelocities] = {[2] = 500}
                })
            end)

            Timer.after(0.2, function()
                Timer.tween(2, {
                    [slotVelocities] = {[3] = 500}
                })
            end)
        elseif slotVelocities[1] == 500 then
            Timer.tween(2, {
                [slotVelocities] = {[1] = 30}
            }):finish(function()
                stops[1].target = math.random(3)
            end)
        elseif slotVelocities[2] == 500 then
            Timer.tween(2, {
                [slotVelocities] = {[2] = 30}
            }):finish(function()
                stops[2].target = math.random(3)
            end)
        elseif slotVelocities[3] == 500 then
            Timer.tween(2, {
                [slotVelocities] = {[3] = 30}
            }):finish(function()
                stops[3].target = math.random(3)
            end)
        end
    end
end

function love.update(dt)

    Timer.update(dt)

    -- scroll all of the reels
    for i = 1, 3 do
        for k, icon in pairs(slotReels[i]) do
            icon.y = icon.y - slotVelocities[i] * dt
        end
    end

    -- loop reel if necessary
    for i = 1, 3 do
        if slotReels[i][1].y < SLOT_LOOP_Y then
            table.insert(slotReels[i], table.remove(slotReels[i], 1))
            slotReels[i][#slotIcons].y = slotReels[i][#slotIcons-1].y + ICON_SIZE

            -- only check if we have a target
            if stops[i].target > 0 then
                stops[i].total = stops[i].total + 1

                if stops[i].target == stops[i].total then
                    slotVelocities[i] = 0
                    stops[i].total = 0
                    stops[i].target = 0

                    -- check for win and flag slot as finished running
                    if slotVelocities[1] == slotVelocities[2] and slotVelocities[1] == slotVelocities[3] then
                        running = false

                        if slotReels[1][2].icon == slotReels[2][2].icon and slotReels[1][2].icon == slotReels[3][2].icon then
                            win = true
                        end
                    end
                end
            end
        end
    end
end

function love.draw()
    love.graphics.draw(gTextures['casino'], 0, -100)

    -- draw slot reels
    for i = 1, 3 do
        for k, v in pairs(slotReels[i]) do

            if v.y > 140 and v.y < 400 then
                love.graphics.draw(
                    gTextures[v.icon], v.x, v.y)
            end
        end
    end

    if win then
        love.graphics.setColor(1, 1, 1, 0.2)
        for i = 1, 3 do
            love.graphics.rectangle('fill', slotReels[i][2].x + 2, slotReels[i][2].y,
                62, 64)
        end
        love.graphics.setColor(1, 1, 1, 1)
    end

    love.graphics.draw(gTextures['slot-machine'], slotPadding, 0)
end