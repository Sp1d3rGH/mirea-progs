using HorizonSideRobots

function chess_marking(r::Robot)
    back_track = go_to_bottom_left_corner_return_path(r)
    mark_current = !(isodd(length(back_track))) # Если длина back_track чётная, красим левую нижнюю клетку
    side = Ost
    while !(isborder(r, Nord) && isborder(r, side))
        if mark_current
            putmarker!(r)
        end
        
        if (isborder(r, Ost) || isborder(r, West)) && !(isborder(r, Sud) && isborder(r, West)) && !(isborder(r, Nord))
            move!(r, Nord)
            mark_current = !mark_current
            if mark_current
                putmarker!(r)
            end
            side = HorizonSide(mod(Int(side) + 2, 4))
        end

        if !(isborder(r, side))
            move!(r, side)
            mark_current = !mark_current
        end
    end
    if mark_current
        putmarker!(r)
    end

    go_to_bottom_left_corner_return_path(r)
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