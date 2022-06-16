using HorizonSideRobots

function mark_inner_rectangle(r::Robot)
    back_track = go_to_bottom_left_corner_return_path(r)
    i = 0
    while isborder(r, Ost) == false
        move!(r, Ost)
        i = i + 1
    end

    n = i
    m = Ost
    while n == i
        move!(r, Nord)
        n = 0
        m = HorizonSide(mod(Int(m) + 2, 4))
        while isborder(r, m) == false
            move!(r, m)
            n += 1
        end
    end

    circle_n_mark_rectangle(r, m)

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

function circle_n_mark_rectangle(r, side)
    while isborder(r, side) == true # Красим со стороны
        putmarker!(r)
        move!(r, Nord)
    end
    putmarker!(r)
    move!(r, side)

    while isborder(r, Sud) == true # Красим сверху
        putmarker!(r)
        move!(r, side)
    end
    putmarker!(r)
    move!(r, Sud)

    while isborder(r, HorizonSide(mod(Int(side)+2, 4))) == true # Красим с другой стороны
        putmarker!(r)
        move!(r, Sud)
    end
    putmarker!(r)
    move!(r, HorizonSide(mod(Int(side)+2, 4)))
    
    while isborder(r, Nord) == true # Красим снизу
        putmarker!(r)
        move!(r, HorizonSide(mod(Int(side)+2, 4)))
    end
    putmarker!(r)
end

function back_by_path_o_sides(r, path::Array)
    n = length(path)
    while n > 0
        move!(r, path[n])
        n = n - 1
    end
end