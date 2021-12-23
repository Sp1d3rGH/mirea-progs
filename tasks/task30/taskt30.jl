using HorizonSideRobots

function mark_field_with_horizontal_obstacles(r)
    back_track = go_to_bottom_left_corner_return_path(r)

    while isborder(r, Nord) == false
        mark_n_back(r, Ost)
        putmarker!(r)
        move!(r, Nord)
    end

    mark_n_back(r, Ost)
    putmarker!(r)
    while isborder(r, Sud) == false
        move!(r, Sud)
    end

    back_by_path_o_sides(r, back_track)
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

function mark_n_back(r::Robot, side::HorizonSide)
    while isborder(r, side) == false
        move!(r, side)
        putmarker!(r)
    end
    while ismarker(r)==true 
        move!(r, HorizonSide(mod(Int(side) + 2, 4))) # В противоположную сторону
    end
end