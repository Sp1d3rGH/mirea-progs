using HorizonSideRobots

<<<<<<< HEAD
function маркировать_периметр_на_поле_с_маркерами(r::Robot)
    путь = перейти_в_левый_нижний_угол_и_вернуть_путь(r)
    for i ∈ (Ost, Nord, West, Sud)
        маркировать_направление(r, i)
    end
    пройти_по_пути(r, путь)
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

function пройти_по_пути(r,путь::Array)
    n=length(путь)
    while n>0
        move!(r,путь[n])
        n=n-1
=======
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
>>>>>>> 989ebe7250709017f27742ae7c540a1e350aa969
    end
end