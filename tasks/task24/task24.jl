using HorizonSideRobots

function max_area_rectangle(r::Robot)
    go_to_bottom_left_corner_return_path(r)

    max_s = 0
    current_w = 0
    current_h = 0 
    border_now = false
    side = Ost

    while isborder(r, Nord) == false
        while move_if_possible!(r, side)
            current_w, current_h, border_now = find_rectangle_w_h!(r, current_w, current_h, border_now, side)
            if current_h * current_w > max_s
                max_s = current_h * current_w
            end
        end
        current_w, current_h, border_now = find_rectangle_w_h!(r, current_w, current_h, border_now, side)
        if current_h * current_w > max_s
            max_s = current_h * current_w
        end
    

        side = HorizonSide(mod(Int(side)+2, 4))
        move!(r, Nord)
        current_w, current_h, border_now = find_rectangle_w_h!(r, current_w, current_h, border_now, side)
        if current_h * current_w > max_s
            max_s = current_h * current_w
        end
        
    end

    return max_s
end

function find_rectangle_w_h!(r::Robot, x::Int, y::Int, border_now::Bool, move_side::HorizonSide)
    if isborder(r, Nord) && !border_now
        border_now = true
        x = 0
        y = 0
    end

    if !isborder(r, Nord) && border_now
        border_now = false
        move!(r, Nord)
        while isborder(r, HorizonSide(mod(Int(move_side)+2, 4))) 
            y += 1
            move!(r, Nord)
        end
        for i ∈ 1:y
            move!(r, Sud)
        end
        move!(r, Sud)

    end

    if border_now
        x += 1
    end

    return x, y, border_now
end



function move_if_possible!(r::Robot, side::HorizonSide)::Bool # Функция подвинет робота, а если есть препятствие, он его обогнёт
    orthogonal_side = HorizonSide(mod(Int(side) + 1, 4)) # Следующее против часовой стрелки
    reverse_side = HorizonSide(mod(Int(orthogonal_side)+2, 4))
    num_steps = 0
    if isborder(r,side)==false
        move!(r,side)
        result=true
    else
        while isborder(r,side) == true
            if isborder(r, orthogonal_side) == false
                move!(r, orthogonal_side)
                num_steps += 1
            else
                break
            end
        end
        if isborder(r,side) == false
            move!(r,side)
            while isborder(r,reverse_side) == true
                move!(r,side)
            end
            result = true
        else
            result = false
        end
        while num_steps>0
            num_steps=num_steps-1
            move!(r,reverse_side)
        end
    end
    return result
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