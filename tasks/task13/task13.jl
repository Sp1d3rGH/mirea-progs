using HorizonSideRobots

function x_cross_marking(r::Robot)
    for i in (Nord, Sud)
        for j in (Ost, West)
            diagonal_marking(r, i, j)
        end
    end
end

function diagonal_marking(r::Robot, s1::HorizonSide, s2::HorizonSide)
    k = 0
    while (isborder(r, s1) == false) && (isborder(r, s2) == false)
        putmarker!(r)
        move!(r, s1)
        move!(r, s2)
        k = k + 1
    end
    putmarker!(r)
    i = HorizonSide(mod(Int(s1) + 2, 4))
    j = HorizonSide(mod(Int(s2) + 2, 4))
    while k > 0 
        k = k - 1
        move!(r, i)
        move!(r, j)
    end
end