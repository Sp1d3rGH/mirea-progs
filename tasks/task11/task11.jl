using HorizonSideRobots

function cross_border_cells_marking(r::Robot)
    back_track = []
    vertical_shift = 0
    horizontal_shift = 0
    while ((isborder(r, Sud)) && (isborder(r, West))) == false
        push!(back_track, show_path_after_moving(r, West))
        push!(back_track, show_path_after_moving(r, Sud))
    end
    
    n = length(back_track)
    for i in 1:n
        if (i % 2) == false
            vertical_shift += back_track[i]
        else
            horizontal_shift += back_track[i]
        end
    end


    for i in 1:horizontal_shift
        move!(r, Ost)
    end
    putmarker!(r)
    while isborder(r, Ost) == false
        move!(r, Ost)
    end
    for i in 1:vertical_shift
        move!(r, Nord)
    end
    putmarker!(r)
    while isborder(r, Nord) == false
        move!(r, Nord)
    end

    while isborder(r, West) == false
        move!(r, West)
    end

    for i in 1:horizontal_shift
        move!(r, Ost)
    end
    putmarker!(r)
    while isborder(r, West) == false
        move!(r, West)
    end
    while isborder(r, Sud) == false
        move!(r, Sud)
    end
    for i in 1:vertical_shift
        move!(r, Nord)
    end
    putmarker!(r)
    while isborder(r, Sud) == false
        move!(r, Sud)
    end

    while n > 0
        if n % 2 == 1
            side = Ost
        else
            side = Nord
        end
        move_n(r, side, back_track[n])
        n -= 1
    end
end





function move_n(r::Robot, side::HorizonSide, n::Int)
    for i in 1:n
        move!(r, side)
    end
end

function show_path_after_moving(r::Robot, side::HorizonSide)
    n = 0
    while isborder(r, side)==false
        move!(r, side)
        n = n + 1
    end 
    return n
end