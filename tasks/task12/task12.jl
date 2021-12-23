using HorizonSideRobots

function n_size_chess_marking(r::Robot,n::Int)
    x, y = go_to_bottom_left_corner_return_coords_shift_of_start(r)
    
    all = show_path_after_moving(r, Nord)+1
    while isborder(r, Sud) == false
        move!(r, Sud)
    end

    side=Nord
    t=0
    while isborder(r, Ost) == false
        if n <= t < 2n
            for i in 1:n
                move!(r,side)
            end
        end

        direction_mark(r,side,n,all)

        t = t + 1
        if t > 2n
            t -= 2n
        end

        move!(r, Ost)
        side = HorizonSide(mod(Int(side) + 2, 4))
        show_path_after_moving(r, side)
        side = HorizonSide(mod(Int(side) + 2, 4))
    end
    if n <= t < 2n
        for i in 1:n
            move!(r, side)
        end
    end
    direction_mark(r, side, n, all)

    go_to_bottom_left_corner_return_coords_shift_of_start(r)
    move_n(r, Ost, x)
    move_n(r, Nord, y)
end


function direction_mark(r::Robot, side::HorizonSide, n::Int, all::Int)
    k = 0
    p = 0
    while isborder(r, side) == false
        p = 0
        for i in 1:n
            if isborder(r, side) == false
                putmarker!(r)
                move!(r, side)
                k = k + 1
                p += 1
            end
        end
        if (isborder(r, side) == true) && (p != n)
            putmarker!(r)
        end
        for j in 1:n
            if isborder(r, side) == false
                move!(r, side)
                k += 1
            end
        end
    end
    l = 2n + 1
    while all >= l
        if all == l
            move!(r, HorizonSide(mod(Int(side) + 2, 4)))
            if ismarker(r) == false
                move!(r, side)
                putmarker!(r)
            end
        end
        l= l + 3n
    end
    return k
end






function go_to_bottom_left_corner_return_coords_shift_of_start(r::Robot)
    x=0
    y=0
    while isborder(r, West) == false
        move!(r, West)
        x = x + 1
    end
    while isborder(r, Sud) == false
        move!(r, Sud)
        y = y + 1
    end
    return x, y
end

function show_path_after_moving(r::Robot, side::HorizonSide)
    n = 0
    while isborder(r, side) == false
        move!(r, side)
        n = n + 1
    end 
    return n
end

function move_n(r::Robot, side::HorizonSide, n::Int)
    for i in 1:n
        move!(r, side)
    end
end