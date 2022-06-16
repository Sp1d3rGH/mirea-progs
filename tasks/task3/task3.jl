using HorizonSideRobots

function all_field_marking(r::Robot)
    back_track = go_to_bottom_left_corner_return_path(r)

    mark_field_left_to_right(r, Nord)

    if isborder(r, Sud)
        markside(r, Nord)
    end
    markside(r, Sud)

    go_to_bottom_left_corner_return_path(r)
    back_by_path_o_sides(r, back_track)
end

function mark_field_left_to_right(r::Robot, side::HorizonSide)
    while isborder(r, Ost) == false
        while isborder(r, side) == false
            putmarker!(r)    
            move!(r, side)
        end
        putmarker!(r)

        side = HorizonSide(mod(Int(side) + 2, 4))
        move!(r, Ost)
    end
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