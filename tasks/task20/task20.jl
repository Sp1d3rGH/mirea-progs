using HorizonSideRobots

function count_horizontal_obstacles(r)
    back_track = go_to_bottom_left_corner_return_path(r)
    count = 0

    while isborder(r, Nord) == false
        count += count_upper_obstacles(r, Ost)
        move!(r, Nord)
    end

    while isborder(r, Sud) == false
        move!(r, Sud)
    end

    back_by_path_o_sides(r, back_track)
    print(count)
end



function go_to_bottom_left_corner_return_path(r::Robot)::Array
    path = []
    while (isborder(r, Sud) == false) || (isborder(r, West) == false)
        if isborder(r, Sud) == false
            move!(r, Sud)
            push!(path, Nord)
        end
        if isborder(r, West) == false
            move!(r, West)
            push!(path, Ost)
        end
    end
    return path
end

function back_by_path_o_sides(r, path::Array)
    n = length(path)
    while n > 0
        move!(r, path[n])
        n = n - 1
    end
end

function count_upper_obstacles(r::Robot, side::HorizonSide)
    count = 0
    obstacle_above = false
    while isborder(r, side) == false
        move!(r, side)
        if (isborder(r, Nord) == true) && (obstacle_above == false)
            obstacle_above = true
            count += 1
        end
        if isborder(r, Nord) == false
            obstacle_above = false
        end
    end
    while isborder(r, HorizonSide(mod(Int(side) + 2, 4)))==false 
        move!(r, HorizonSide(mod(Int(side) + 2, 4)))
    end
    return count
end