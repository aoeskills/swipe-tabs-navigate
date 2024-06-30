local pressFn = table.unpack(require('sugar'))

-- functions that execute tab navigation, replace your own shortcuts
local previousTabFn = pressFn({'cmd'}, '[')
local nextTabFn = pressFn({'cmd'}, ']')

-- constants for manipulate threshold
-- 1 means 100% of trackpad, 0.01 means 1% of trackpad,
-- it's not very accurate due to acceleration
local INIT_THRESHOLD = 0.02
local CONTINUE_THRESHOLD = 0.03

-- currentSwipeID   : to identify different swipe.
-- threshold        : swipe ferther then this distance will trigger tab navigation,
--                    it will continously increase in same swipe to trigger multiple times.
-- previousDirection: to detect if direction is changed
local currentSwipeID, threshold, previousDirection

-- import Swipe module
Swipe = hs.loadSpoon("Swipe")
Swipe:start(3, function(direction, distance, swipeID)
    if swipeID == currentSwipeID then
        -- reset threshold if dir is change
        if(previousDirection == "left" and direction == "right") then
            threshold = INIT_THRESHOLD
        elseif(previousDirection == "right" and direction == "left") then
            threshold = INIT_THRESHOLD
        end

        if distance > threshold then
            -- threshold = math.huge -- only trigger once per swipe
            threshold = threshold + CONTINUE_THRESHOLD -- increase threshold whenever it triggered

            if direction == "left" then
                previousTabFn()
                previousDirection = "left"

            elseif direction == "right" then
                nextTabFn()
                previousDirection = "right"
            end
        end
    else
        currentSwipeID = swipeID
        threshold = INIT_THRESHOLD
        print('reset threshold',threshold)
    end
end)
