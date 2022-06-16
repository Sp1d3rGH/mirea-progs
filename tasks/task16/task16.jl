using HorizonSideRobots

<<<<<<< HEAD
function маркировать_поле_с_перегородками(r::Robot)
    x=Ost
    y=Nord
    путь = перейти_в_левый_нижний_угол_и_вернуть_путь(r)
    while isborder(r,x)==false
        маркировать_направление(r,y)
        if !isborder(r,x)
            move!(r,x)
        end
        side_vert=инвертировать_направление(y)
    end
    маркировать_направление(r,y)
    перейти_в_левый_нижний_угол(r)
    пройти_по_пути(r,путь)
end

function маркировать_направление(r::Robot,side::HorizonSide)
    putmarker!(r)
    while пройти_в_направлении_если_возможно(r,side) == true
        putmarker!(r)
    end
    while пройти_в_направлении_если_возможно(r,инвертировать_направление(side))
        ;
    end
end


function перейти_в_левый_нижний_угол_и_вернуть_путь(r::Robot) ::Array
    путь=[]
    while isborder(r,Sud)==false || isborder(r,West)==false
        if isborder(r,Sud)==false
            move!(r,Sud)
            push!(путь,Nord)
        end
        if isborder(r,West)==false
            move!(r,West)
            push!(путь,Ost)
        end
    end
    return путь
end

function маркировать_направление(r,side::HorizonSide) # markside
    while isborder(r,side)==false
        putmarker!(r)    
        move!(r,side)
    end
    putmarker!(r)
end

инвертировать_направление(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))

function перейти_в_левый_нижний_угол(r::Robot)
    while isborder(r,West)==false || isborder(r,Sud)==false
        if isborder(r,West)==false
            move!(r,West)
        end
        if isborder(r,Sud)==false
            move!(r,Sud)
        end
    end
end

function пройти_по_пути(r,путь::Array)
    n=length(путь)
    while n>0
        move!(r,путь[n])
        n=n-1
    end
end

function пройти_в_направлении_если_возможно(r::Robot, direct_side::HorizonSide)::Bool
    orthogonal_side = следующее_по_часовой_стрелке_направление(direct_side)
    reverse_side = инвертировать_направление(orthogonal_side)
    num_steps=0
    if isborder(r,direct_side)==false
        move!(r,direct_side)
        result=true
    else
        while isborder(r,direct_side) == true
            if isborder(r, orthogonal_side) == false
                move!(r, orthogonal_side)
                num_steps += 1
=======
function all_field_with_obstacles_marking(r::Robot)
    back_track = go_to_bottom_left_corner_return_path(r)

    while isborder(r, Ost) == false
        n = direction_marking_return_steps_count(r, Nord) # Записывает пройденный путь, маркируя при этом клетки
        for i in 1:n # Вернуться по n шагов через препятствия
            move_through_obstacle(r, HorizonSide(mod(Int(Nord) + 2, 4)))
        end
        putmarker!(r)
        move!(r, Ost)
    end
    while isborder(r, Nord) == false
        putmarker!(r)    
        move!(r, Nord)
    end
    putmarker!(r)

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

function direction_marking_return_steps_count(r::Robot, side::HorizonSide)
    n = 0 
    while move_through_obstacle(r, side) == true
        putmarker!(r)
        n += 1
    end 
    return n
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

function move_through_obstacle(r::Robot, forward_side::HorizonSide)::Bool
    side_side = HorizonSide(mod(Int(forward_side) - 1, 4)) # Направление в сторону обхода
    otherside_side = HorizonSide(mod(Int(side_side) + 2, 4)) # Обратное направление в сторону
    n = 0
    if isborder(r,forward_side)==false
        move!(r,forward_side)
        not_hit_border=true
    else
        while isborder(r,forward_side) == true
            if isborder(r, side_side) == false
                move!(r, side_side)
                n += 1
>>>>>>> 989ebe7250709017f27742ae7c540a1e350aa969
            else
                break
            end
        end
<<<<<<< HEAD
        if isborder(r,direct_side) == false
            move!(r,direct_side)
            while isborder(r,reverse_side) == true
                move!(r,direct_side)
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

следующее_по_часовой_стрелке_направление(side::HorizonSide) = HorizonSide(mod(Int(side)-1,4))
=======
        if isborder(r,forward_side) == false
            move!(r,forward_side)
            while isborder(r, otherside_side) == true
                move!(r,forward_side)
            end
            not_hit_border = true
        else
            not_hit_border = false
        end
        while n > 0
            n -= 1
            move!(r, otherside_side)
        end
    end
    return not_hit_border
end
>>>>>>> 989ebe7250709017f27742ae7c540a1e350aa969
