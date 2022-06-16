using HorizonSideRobots

function sides_marking_n_return(r::Robot)
    back_track = go_to_bottom_left_corner_return_path(r)
    for side in (Ost, Nord, West, Sud)
        while isborder(r, side) == false
            putmarker!(r)    
            move!(r, side)
        end
        putmarker!(r)
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