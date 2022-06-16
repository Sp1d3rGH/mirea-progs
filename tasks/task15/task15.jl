using HorizonSideRobots

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
    end
end