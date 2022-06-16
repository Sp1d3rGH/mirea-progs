#Реализация метода Ньютона

"""
function newton(r::Function, x_0; epsilon = 1e-8, max_num_iter = 20)

Ищет корень уравнения f(x)=0
-- r(x)= -f(x)/f'(x)
-- x_0 - начальное приближение
-- epsilon > 0 - пераметр, определяющий точность вычислений
(критерй останова: |x - x_prev| = |r(x_prev)| <= epsilon)
-- max_num_iter - максимальное число итераций
"""

function newton(r::Function, x; epsilon = 1e-8, max_num_iter = 20)
    num_iter = 0
    r_x = r(x)
    while num_iter < max_num_iter && abs(r_x) > epsilon
        x += r_x
        r_x = r(x)
        num_iter += 1
    end

    if abs(r_x) <= epsilon
        return x
    else
        return NaN
    end
end

#С помощью функции newton решить уравнение cos(x) = x
# f(x) = cos(x)-x
# f'(x) = -sin(x)-1
# r(x) = -f(x)/f'(x) = (cos(x)-x)/(sin(x)+1)
newton(x -> (cos(x)-x)/(sin(x)+1), 0.5)

#Функция polyval, возвращающей значение многочлена и его производной в заданной точке
function polyval(P,x)
    dQ = 0
    Q = P[1]
    for i in 2:length(P)
        dQ = dQ*x + Q
        Q = Q*x + P[i]
    end
    return Q, dQ
end

function r(P, x) #P - внешняя переменная, содержащая коэффициенты многочлена, следующих в порядке убывания степеней
    y, dy = polyval(P, x)
    return -y/dy
end

function newton2(r::Function, x_0; epsilon = 1e-8, max_num_iter = 20)
    num_iter = 0
    r_x = -r(x) / ((r(x+h) + r(x)) / epsilon)
    while num_iter < max_num_iter && abs(r_x) > epsilon
        x += r_x
        r_x = -r(x) / ((r(x + epsilon) + r(x)) / epsilon)
        num_iter += 1
    end
    if abs(r_x) <= epsilon
        return x
    else
        return nothing
    end
    
end
