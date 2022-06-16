using HorizonSideRobots

<<<<<<< HEAD
function lab_20(r)
    go_to_west_south_corner_and_return_path!(r; go_around_barriers = true)

    my_ans = 0
    border_now = false
    side = Ost
    while !isborder(r, Nord)
        
        while !isborder(r, side)
            my_ans, border_now = find_special!(r, my_ans, border_now, Nord)
            move!(r,side)
        end
        my_ans, border_now = find_special!(r, my_ans, border_now, Nord)

        side = inverse_side(side)
        move!(r, Nord)
    end
    return my_ans
end

function find_special!(r::Robot, my_ans::Int, border_now::Bool, side::HorizonSide)
    if isborder(r, side)
        border_now = true
    end
    if !isborder(r, side) && border_now
        border_now = false
        my_ans += 1
    end
    return my_ans, border_now
end



function go_to_west_south_corner_and_return_path!(r::Robot; go_around_barriers::Bool = false, markers = false)::Array{Tuple{HorizonSide,Int64},1}
    my_ans = []
    a = go_to_border_and_return_path!(r, West; go_around_barriers, markers)
    b = go_to_border_and_return_path!(r, Sud; go_around_barriers, markers)

    for i in a
        push!(my_ans, i)
    end
    for i in b
        push!(my_ans, i)
    end
    return my_ans
end

function inverse_side(side::HorizonSide)::HorizonSide
    return HorizonSide(mod(Int(side)+2, 4))
end

function go_to_border_and_return_path!(r::Robot, side::HorizonSide; go_around_barriers::Bool = false, markers = false)::Array{Tuple{HorizonSide,Int64},1}
    my_ans = [ (Nord, 0) ]
    if go_around_barriers
        steps = 0
        if markers
            putmarker!(r)
        end
        if !isborder(r, side)
            move!(r, side)
            steps = 1
            push!(my_ans, (inverse_side(side), 1) )
        else
            path = go_around_barrier_and_return_path!(r, side)
            steps = get_path_length_in_direction(path, side)
            for i in path
                push!(my_ans, i)
            end
        end
        if markers
            putmarker!(r)
        end
        while steps > 0
            if !isborder(r, side)
                move!(r, side)
                steps = 1
                push!(my_ans, (inverse_side(side), 1) )
                if markers
                    putmarker!(r)
                end
            else
                path = go_around_barrier_and_return_path!(r, side)
                steps = get_path_length_in_direction(path, side)
                for i in path
                    push!(my_ans, i)
                end
                if markers
                    putmarker!(r)
                end
            end
        end

    else
        steps=0
        steps_now = go!(r,side; markers)
        while steps_now > 0
            steps += steps_now
            steps_now = go!(r,side; markers)
        end
        push!(my_ans, (inverse_side(side), steps) )
    end
    return my_ans
end

function go_around_barrier_and_return_path!(r::Robot, direct_side::HorizonSide)::Array{Tuple{HorizonSide,Int64},1}
    my_ans = []
    orthogonal_side = clockwise_side(direct_side)
    reverse_side = inverse_side(orthogonal_side)
    num_of_orthohonal_steps = 0
    num_of_direct_steps = 0

    if !isborder(r, direct_side)
        my_ans = [ (Nord, 0) ]
    else
        while isborder(r,direct_side) == true
            if isborder(r, orthogonal_side) == false
                move!(r, orthogonal_side)
                num_of_orthohonal_steps += 1
            else
                break
            end
        end        

        if isborder(r,direct_side) == false
            move!(r,direct_side)
            num_of_direct_steps += 1
            while isborder(r,reverse_side) == true
                num_of_direct_steps += 1
                move!(r,direct_side)
            end
            push!(my_ans, (inverse_side(orthogonal_side), num_of_orthohonal_steps) )
            push!(my_ans, (inverse_side(direct_side), num_of_direct_steps) )
            push!(my_ans, (inverse_side(reverse_side), num_of_orthohonal_steps) )
        else
            my_ans = [ (Nord, 0) ]
        end

        while num_of_orthohonal_steps > 0
            num_of_orthohonal_steps=num_of_orthohonal_steps-1
            move!(r,reverse_side)
        end

    end
    return my_ans
end

function clockwise_side(side::HorizonSide)::HorizonSide
    return HorizonSide(mod(Int(side)-1,4))
end

function get_path_length_in_direction(path::Array{Tuple{HorizonSide,Int64},1}, direction::HorizonSide)::Int
    my_ans = 0
    for i in path
        (i[1] == direction || i[1] == inverse_side(direction)) ? my_ans += i[2] : Nothing
    end
    return my_ans
=======
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
>>>>>>> 989ebe7250709017f27742ae7c540a1e350aa969
end