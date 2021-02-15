start_relative_coords = {x=0, y=0, z=0}

current_relative_coords = start_relative_coords

start_facing = "south"

current_facing = start_facing

hole_start = {x=3, y=-1, z=3}

hole_size = {length = 16, height = 2, width = 16}

last_at = hole_start

enderchest_slot = 16

-- na sever gre x+, na jug gre x-
-- na vzhod(east) je z+, na zahod z-
-- gor y+ dol y-

function refuel()
    previous_slot = turtle.getSelectedSlot()
    for i=1, 16, 1 do
        turtle.select(i)
        data = turtle.getItemDetail()
        if data then
            if data.name == "minecraft:coal" then
                turtle.refuel(data.count)
            end
        end
    end
    turtle.select(previous_slot)
end

function updateFacingLeft()
    if current_facing == "north" then
        current_facing = "west"
    elseif current_facing == "west" then
        current_facing = "south"
    elseif current_facing == "south" then
        current_facing = "east"
    elseif current_facing == "east" then
        current_facing = "north"
    end
end

function checkInventory()
    previous_slot = turtle.getSelectedSlot()
    full_slots = 0
    for i=1, 16, 1 do
        turtle.select(i)
        data = turtle.getItemDetail()
        if data then
            if data.count > 0 then
                full_slots = full_slots + 1
            end
        end
    end
    turtle.select(previous_slot)
    if full_slots < 16 then
        do return false end
    elseif full_slots == 16 then
        do return true end
    end
end

function emptyInventory()
    previous_slot = turtle.getSelectedSlot()
    turtle.select(enderchest_slot)
    turtle.placeUp()
    refuel()
    for i=1, 16, 1 do
        turtle.select(i)
        turtle.dropUp()
    end
    turtle.select(enderchest_slot)
    turtle.digUp()
    turtle.select(previous_slot)
end

function goto_coords(coords)
    while true do
        if coords.x > current_relative_coords.x then --north
            if current_facing ~= "north" then
                if current_facing == "south" then
                    turtle.turnLeft()
                    turtle.turnLeft()
                    current_facing = "north"
                elseif current_facing == "east" then
                    turtle.turnLeft()
                    current_facing = "north"
                elseif current_facing == "west" then
                    turtle.turnLeft()
                    turtle.turnLeft()
                    turtle.turnLeft()
                    current_facing = "north"
                end
            end
            if turtle.forward() then
                current_relative_coords.x = current_relative_coords.x + 1
                refuel()
            else
                while turtle.detect() do
                    turtle.dig()
                end
                turtle.forward()
                current_relative_coords.x = current_relative_coords.x + 1
                refuel()
            end

        elseif coords.x < current_relative_coords.x then --south
            if current_facing ~= "south" then
                if current_facing == "north" then
                    turtle.turnLeft()
                    turtle.turnLeft()
                    current_facing = "south"
                elseif current_facing == "west" then
                    turtle.turnLeft()
                    current_facing = "south"
                elseif current_facing == "east" then
                    turtle.turnLeft()
                    turtle.turnLeft()
                    turtle.turnLeft()
                    current_facing = "south"
                end
            end
            if turtle.forward() then
                current_relative_coords.x = current_relative_coords.x - 1
                refuel()
            else
                while turtle.detect() do
                    turtle.dig()
                end
                turtle.forward()
                current_relative_coords.x = current_relative_coords.x - 1
                refuel()
            end
        end

        ----------

        if coords.z > current_relative_coords.z then --east
            if current_facing ~= "east" then
                if current_facing == "south" then
                    turtle.turnLeft()
                    current_facing = "east"
                elseif current_facing == "west" then
                    turtle.turnLeft()
                    turtle.turnLeft()
                    current_facing = "east"
                elseif current_facing == "north" then
                    turtle.turnLeft()
                    turtle.turnLeft()
                    turtle.turnLeft()
                    current_facing = "east"
                end
            end
            if turtle.forward() then
                current_relative_coords.z = current_relative_coords.z + 1
                refuel()
            else
                while turtle.detect() do
                    turtle.dig()
                end
                turtle.forward()
                current_relative_coords.z = current_relative_coords.z + 1
                refuel()
            end

        elseif coords.z < current_relative_coords.z then --west
            if current_facing ~= "west" then
                if current_facing == "north" then
                    turtle.turnLeft()
                    current_facing = "west"
                elseif current_facing == "east" then
                    turtle.turnLeft()
                    turtle.turnLeft()
                    current_facing = "west"
                elseif current_facing == "south" then
                    turtle.turnLeft()
                    turtle.turnLeft()
                    turtle.turnLeft()
                    current_facing = "west"
                end
            end
            if turtle.forward() then
                current_relative_coords.z = current_relative_coords.z - 1
                refuel()
            else
                while turtle.detect() do
                    turtle.dig()
                end
                turtle.forward()
                current_relative_coords.z = current_relative_coords.z - 1
                refuel()
            end
        end

        ------

        if coords.y > current_relative_coords.y then --up
            if turtle.up() then
                current_relative_coords.y = current_relative_coords.y + 1
                refuel()
            else
                while turtle.detectUp() do
                    turtle.digUp()
                end
                turtle.up()
                current_relative_coords.y = current_relative_coords.y + 1
                refuel()
            end

        elseif coords.y < current_relative_coords.y then --down
            if turtle.down() then
                current_relative_coords.y = current_relative_coords.y - 1
                refuel()
            else
                while turtle.detectDown() do
                    turtle.digDown()
                end
                turtle.down()
                current_relative_coords.y = current_relative_coords.y - 1
                refuel()
            end
        end

        if coords.x == current_relative_coords.x then
            if coords.z == current_relative_coords.z then
                if coords.y ==  current_relative_coords.y then
                    print("arrived at coords: ", "{", coords.x, ", ", coords.y, ", ", coords.z, "}")
                    do return true end
                end
            end
        end
    end
end

function mine(dimensions)
    --reeeeeeeeeeeeeeeeeeee
    for i=1, dimensions.height, 1 do
        for j=1, dimensions.width/2, 1 do
            for l=1, dimensions.length, 1 do
                if turtle.forward() then
                    if current_facing == "north" then
                        current_relative_coords.x = current_relative_coords.x + 1
                    elseif current_facing == "south" then
                        current_relative_coords.x = current_relative_coords.x - 1
                    elseif current_facing == "east" then
                        current_relative_coords.z = current_relative_coords.z + 1
                    elseif current_facing == "west" then
                        current_relative_coords.z = current_relative_coords.z - 1
                    end
                    refuel()
                    if checkInventory() then
                        --empty the inventory
                        emptyInventory()
                    end
                else
                    while turtle.detect() do
                        turtle.dig()
                    end
                    turtle.forward()
                    if current_facing == "north" then
                        current_relative_coords.x = current_relative_coords.x + 1
                    elseif current_facing == "south" then
                        current_relative_coords.x = current_relative_coords.x - 1
                    elseif current_facing == "east" then
                        current_relative_coords.z = current_relative_coords.z + 1
                    elseif current_facing == "west" then
                        current_relative_coords.z = current_relative_coords.z - 1
                    end
                    refuel()
                    if checkInventory() then
                        --empty the inventory
                        emptyInventory()
                    end
                end
            end

            turtle.turnLeft()
            updateFacingLeft()

            if turtle.forward() then
                if current_facing == "north" then
                    current_relative_coords.x = current_relative_coords.x + 1
                elseif current_facing == "south" then
                    current_relative_coords.x = current_relative_coords.x - 1
                elseif current_facing == "east" then
                    current_relative_coords.z = current_relative_coords.z + 1
                elseif current_facing == "west" then
                    current_relative_coords.z = current_relative_coords.z - 1
                end
                refuel()
                if checkInventory() then
                    --empty the inventory
                    emptyInventory()
                end
            else
                while turtle.detect() do
                    turtle.dig()
                end
                turtle.forward()
                if current_facing == "north" then
                    current_relative_coords.x = current_relative_coords.x + 1
                elseif current_facing == "south" then
                    current_relative_coords.x = current_relative_coords.x - 1
                elseif current_facing == "east" then
                    current_relative_coords.z = current_relative_coords.z + 1
                elseif current_facing == "west" then
                    current_relative_coords.z = current_relative_coords.z - 1
                end
                refuel()
                if checkInventory() then
                    --empty the inventory
                    emptyInventory()
                end
            end

            turtle.turnLeft()
            updateFacingLeft()

            for k=1, dimensions.length, 1 do
                if turtle.forward() then
                    if current_facing == "north" then
                        current_relative_coords.x = current_relative_coords.x - 1
                    elseif current_facing == "south" then
                        current_relative_coords.x = current_relative_coords.x + 1
                    elseif current_facing == "east" then
                        current_relative_coords.z = current_relative_coords.z - 1
                    elseif current_facing == "west" then
                        current_relative_coords.z = current_relative_coords.z + 1
                    end
                    refuel()
                    if checkInventory() then
                        --empty the inventory
                        emptyInventory()
                    end
                else
                    while turtle.detect() do
                        turtle.dig()
                    end
                    turtle.forward()
                    if current_facing == "north" then
                        current_relative_coords.x = current_relative_coords.x - 1
                    elseif current_facing == "south" then
                        current_relative_coords.x = current_relative_coords.x + 1
                    elseif current_facing == "east" then
                        current_relative_coords.z = current_relative_coords.z - 1
                    elseif current_facing == "west" then
                        current_relative_coords.z = current_relative_coords.z + 1
                    end
                    refuel()
                    if checkInventory() then
                        --empty the inventory
                        emptyInventory()
                    end
                end
            end

            turtle.turnLeft()
            updateFacingLeft()
            turtle.turnLeft()
            updateFacingLeft()
            turtle.turnLeft()
            updateFacingLeft()

            if turtle.forward() then
                if current_facing == "north" then
                    current_relative_coords.x = current_relative_coords.x + 1
                elseif current_facing == "south" then
                    current_relative_coords.x = current_relative_coords.x - 1
                elseif current_facing == "east" then
                    current_relative_coords.z = current_relative_coords.z + 1
                elseif current_facing == "west" then
                    current_relative_coords.z = current_relative_coords.z - 1
                end
                refuel()
                if checkInventory() then
                    --empty the inventory
                    emptyInventory()
                end
            else
                while turtle.detect() do
                    turtle.dig()
                end
                turtle.forward()
                if current_facing == "north" then
                    current_relative_coords.x = current_relative_coords.x + 1
                elseif current_facing == "south" then
                    current_relative_coords.x = current_relative_coords.x - 1
                elseif current_facing == "east" then
                    current_relative_coords.z = current_relative_coords.z + 1
                elseif current_facing == "west" then
                    current_relative_coords.z = current_relative_coords.z - 1
                end
                refuel()
                if checkInventory() then
                    --empty the inventory
                    emptyInventory()
                end
            end

            turtle.turnLeft()
            updateFacingLeft()
            turtle.turnLeft()
            updateFacingLeft()
            turtle.turnLeft()
            updateFacingLeft()
        end

        turtle.turnLeft()
        updateFacingLeft()
        turtle.turnLeft()
        updateFacingLeft()
        turtle.turnLeft()
        updateFacingLeft()

        for m=1, 16, 1 do
            if turtle.forward() then
                if current_facing == "north" then
                    current_relative_coords.x = current_relative_coords.x + 1
                elseif current_facing == "south" then
                    current_relative_coords.x = current_relative_coords.x - 1
                elseif current_facing == "east" then
                    current_relative_coords.z = current_relative_coords.z + 1
                elseif current_facing == "west" then
                    current_relative_coords.z = current_relative_coords.z - 1
                end
                refuel()
                if checkInventory() then
                    --empty the inventory
                    emptyInventory()
                end
            else
                while turtle.detect() do
                    turtle.dig()
                end
                turtle.forward()
                if current_facing == "north" then
                    current_relative_coords.x = current_relative_coords.x + 1
                elseif current_facing == "south" then
                    current_relative_coords.x = current_relative_coords.x - 1
                elseif current_facing == "east" then
                    current_relative_coords.z = current_relative_coords.z + 1
                elseif current_facing == "west" then
                    current_relative_coords.z = current_relative_coords.z - 1
                end
                refuel()
                if checkInventory() then
                    --empty the inventory
                    emptyInventory()
                end
            end
        end
        --[[ goto_coords({x=hole_start.x, y=hole_start.y-i, z=hole_start.z}) ]]
        if current_facing ~= "east" then
            if current_facing == "south" then
                turtle.turnLeft()
                current_facing = "east"
            elseif current_facing == "west" then
                turtle.turnLeft()
                turtle.turnLeft()
                current_facing = "east"
            elseif current_facing == "north" then
                turtle.turnLeft()
                turtle.turnLeft()
                turtle.turnLeft()
                current_facing = "east"
            end
        end
        turtle.digDown()
        turtle.down()
        refuel()
        if checkInventory() then
            --empty the inventory
            emptyInventory()
        end
        current_relative_coords.y = current_relative_coords.y - 1
    end
end


goto_coords(hole_start)
mine(hole_size)
--goto_coords(start_relative_coords)

--TODO make it empty inventory if necessery(dump trash, go to chest)
--TODO make it get back after
--TODO make a nice web UI