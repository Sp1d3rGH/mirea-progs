1. Сортирвка пузырьком. issorted, sortperm!, sort!. Сортирвка по значению функции. 

```julia
function bubblesort!(a)
    n = length(a)
    for k in 1:n-1
        is_sorted = false
        for i in firstindex(a):lastindex(a)-k
            if a[i] > a[i+1]
                a[i], a[i+1] = a[i+1], a[i]
                is_sorted = true
            end
        end
        if is_sorted == false
            break
        end
    end
    return a
end
```

issorted(V, lt=isless, by=identity, rev:Bool=false)
Проверяет, является ли заданная последовательность V отсортированной по невозрастанию, или - по неубыванию (в зависимости от значения именованного параметра rev; по умолчанию rev = false и, соответственно, проверяется отсортированность по неубыванию).
Можно передавать в эту функцию последовательности, в которых элементы состоят из своих элементов, к которым можно обращаться с помощью индекса (по умолчанию 1, к другому индексу можно обратиться с помощью by). it - пользовательская функция "меньше, чем ...".
```julia
julia> issorted([(1, "b"), (2, "a")], by = x -> x[2])
false
julia> issorted([(1, "b"), (2, "a")], by = x -> x[2], rev=true)
true
```

sort!(V; alg::Algorithm=defalg(v), lt=isless, by=identity, rev::Bool=false)
Сортирует V по заданному алгоритму. По умолчанию использует QuickSort для числовых массивов и MergeSort для других.
Остальное то же, что и для issorted.
```julia
julia> v = [(1, "c"), (3, "a"), (2, "b")]; sort!(v, by = x -> x[1]); v
3-element Vector{Tuple{Int64, String}}:
(1, "c")
(2, "b")
(3, "a")
```

sortperm(V; alg::Algorithm=DEFAULT_UNSTABLE, lt=isless, by=identity, rev::Bool=false)
Выводит перестановку, которая сортирует V в заданном порядке. Параметры аналогичны sort!.
```julia
julia> v = [3, 1, 2]; p = sortperm(v)
3-element Vector{Int64}:
2
3
1
julia> v[p]
3-element Vector{Int64}:
1
2
3
```
sortperm!(X, V; alg::Algorithm=DEFAULT_UNSTABLE, lt=isless, by=identity, rev::Bool=false, order::Ordering=Forward, initialized::Bool=false)
То же, что и sortperm, но берёт предварительно X. Если initialized имеет значение false, тогда в X записываются значения 1:length(v).
```julia
julia> v = [3, 1, 2]; p = zeros(Int, 3); sortperm!(p, v); p
3-element Vector{Int64}:
2
3
1
julia> v[p]
3-element Vector{Int64}:
1
2
3
```

Пусть имеется последователность (массив) объектов некоторого типа. Ключем будем называть любую вещественно-значную функцию, определенную на объектах данного типа.
Например, если объекты - это числовые векторы, то примерами ключа будут: сумма элементов вектора, максимальное значение абсолютных величин вектора, число нулевых элементов вектора, длина вектора.
Тогда сортировка по значению ключа:
```julia
function sortkey!(key_values, a)
    ind = sortperm!(key_values)
    return a[ind]
end
```

2. findall, findfirst, findlast, filter

findall(f::Function, A)
Выводит массив таких элементов из A, для которых f принимает значение true. Если ничего не нашлось, выводит пустой массив.

findfirst(A)
Выводит индекс первого элемента A, который принимает значение true.
Можно использовать findfirst(f::Function, A), чтобы проверять, если f принимает значение true.

findlast(A)
То же самое, что и findfirst, только выводит индекс последнего такого элемента.

filter(f, a)
Выводит копию a, убирая те элементы, в которых f принимает значение false.

3. Сортирвка столбцов матрицы по ключу. Срезы

Срезом массива называют массив, состоящий из элементов данного массива, и получаемый из данного массива с помощью указания соответствующих диапазонов индексов, и/или векторных индексов.
```julia
A = [  1   2   3   4   5
       6   7   8   9  10
       11  12  13  14  15
       16  17  18  19  20
       21  22  23  24  25]
A[2, 4] # Число 9
A[[1, 3], [2, 4, 5, 2]] # Матрица 2x4:
#[  2   4   5   2
#  12  14  15  12]

#Реализация среза:
function slice(A::AbstractVector, p::AbstractVector{<:Integer})
    temp = typeof(A)()
    for i in p
        push!(temp, A[i])
    end
    return temp
end
```

4. Сортирвка подсчетом

Работает за O(n). Применяемо, если значения элементов сортируемого массива A, являются элементами некоторого заранее известного относительно небольшого множества values. Будем считать, что множество значений values представлено одноименным отсортированным массивом или диапазоном (тут важно только, чтобы выполнялось условие values[i] < values[i+1]).
```julia
function calcsort!(a, values)
    num_val = zeros(Int, size(values))
    for v in a
        num_val[indexvalue(v,values)] += 1 # indexvalue возвращает индекс значения v в наборе значений values.
    end
    k=1
    for i in eachindex(values)
        for j in 1:num_val[i]
            a[k] = values[i]
            k+=1
        end
    end
    return a
end

#indexvalue(v, values::UnionRange) = v - values[1] + 1 # values - это диапазон целых чисел
#indexvalue(v, values::Vector) = findfirst(v, values) # values - это отсортированный вектор значений
```

5. Быстрый поиск в массиве

```julia
function bin_search(a, A, l, r)
    if l > r
        return false
    end
    mid = (l + r + 1) ÷ 2 

    if A[mid] == a 
        return true
    end
    if a > A[mid]
        return bin_search(a, A, i + 1, r)
    else
        return bin_search(a, A, l, i - 1)
    end
end
```

6. Вычисление значения многочлена и его производной в точке по схеме Горнера

(x - значения агрументов, A - значения коэффицентов):
```julia
function evalpoly_(x,A) #Значение
    Q = first(A) # - это есть a_0
    for a in @view A[2:end]
        Q=Q*x+a
    end
    return Q
end

function evaldiffpoly(x,A) #Производная
    Q′=0
    Q=0
    for a in A
        Q′=Q′x+Q
        Q=Q*x+a
    end
    return Q, Q′
end
```

Функция $F:\Sigma\rightarrow U$ называется индуктивной (по А.Г.Кушниренко), если существует такая функция двух переменных (операция) $op: U \times \Omega \rightarrow U$, такая, что для любой последовательности A $\in \Sigma$ и для любого нового элемента a $\in \Omega$,
$$ F([A...,a])=op(F(A),a), $$
где [A..., a] = [A[1], ..., A[end], a]

То есть функция называется индуктивной, если её значение для удлинённой (за счёт добавления элемента a) последовательности можно выразить через значение этой же самой функции для исходной последовательности и через добавляемый элемент.

Функция
$$ F^*: \Sigma \rightarrow U^* $$
называется индуктивным расширение не индуктивной функции $F(A)$, если существует функция
$$ P: U^* \rightarrow U $$
такая, что для любой последовательности $А \in \Sigma$
$$ F(A)=P(F^*(A)) $$
В частности, в случае не индуктивной функции $mean(A)$ её индуктивным расширением будет функция
$$ F^*(A)=(sum(A),length(A)) $$
При этом
$$ mean(A)=\frac{sum(A)}{length(A)}=\frac{F^*(A)[1]}{F^*(A)[2]} $$

7. Сортировка вставками

Работает за O(n^2).
```julia
function insertsort!(array::AbstractVector)
    for i in 2:length(array)
        for j in i-1:-1:1
            if array[i] < array[j]
                swap!(array, i, j)
            end
        end
    end
end
```

8. Циклический сдвиг на k позиций влево и вправо
```julia
function circleShift!(A::AbstractVector, k::Integer)
    k = k%length(A)
    Reverse!(A)
    Reverse!(@view A[begin:k])
    Reverse!(@view A[begin+k:end])

    return A
end

"""Инвертирует массив с 1 по n-k элемент (default k = 0)"""
function Reverse!(A::AbstractVector, k::Integer = 0)
    for i in 1:div(length(A)-k, 2)
        swap!(A, i, length(A)-i+1)
    end
    return A
end
```

9.  Перестановки индексов, проверка, является ли вектор перестрановкой индексов (ispermute), обратна перестановка элементов массива (invpermute)

```julia
function ispermute(p)
    n = length(p)
    used = falses(n) # возвращает нулевой BitVector длины n
    for i in p
        (i in 1:n) && (used[i] ⊻= true) || return false # значек ⊻ - обозначает "исключающее или", проверяем, принадлежат ли числа диапазону (1:n) и различны ли они.
    end
    return true
end

function invpermute!(A, p)
    for i in p
        if i > 0
            A[i], A[p[i]] = A[p[i]], A[i]
            p[i] = -p[i]
        end
    end
    for i in eachindex(p)
        p[i] = -p[i]
    end
    return A   
end
```

10.  Прямая перестановка элементов массива (permute)

```julia
function permute!(A, p) 
    for i in eachindex(p)
        if p[i] < 0
            continue
        end 
        # i - начало очередной циклической перестановки индексов массива A            
        buff = A[i]
        j_prew, j = i, p[i] # - индекс элемента исходного массива, который требуется переместить на i-ю позицию                  
        p[i] = -p[i]
        while j != i # - пока циклическая перестановка индексов не "замкнулась"               
            A[j_prew] = A[j]
            j_prew, j = j, p[j]            
            p[j_prew] = -p[j_prew]
        end        
        A[j_prew] = buff 
        # перемещения элементов массива A по очередному циклу (по очередной циклической перестановке индексов) полностью завершены
    end
    for i in eachindex(p)
        p[i] = -p[i]
    end        
    return A
end
```

11.  Однопроходный алгоритм вычисления СКО

Квадрат среднеквадратического отклонения от среднего значения - это среднее арифметическое кваратов всех от всех отклонений от среднего значения.

```julia
function standard_deviation(A)
    Sx = 0
    Sx2 = 0
    for i in firstindex(A):lastindex(A)
        Sx += i
        Sx2 += i*i
    end
    return sqrt((Sx2 / length(A)) - ((Sx/ length(A))*(Sx/ length(A))))
end
```

12.   Инвариант цикла. Быстрая сортировка Хоара

Инвариантом цикла (с предусловием) называют утверждение (предикат), зависящее от фазовых переменных цикла (т.е. переменнных, которые могут изменяться в теле цикла), имеющее значение "истина" как до начала цикла, так и после любого числа его повторений.

Работает за O(nlogn).
```julia
function quick_sort!(A)
    length(A) <= 1 && return A
    N = length(A)
    left, right = part_sort!(A, A[rand(1:N)]) #"базовый" элемент массива выбирается случайнам образом
    quick_sort!(left)
    quick_sort!(right)
    return A
end

function part_sort!(A, b)
    N = length(A)
    K=0
    L=0
    M=N
    #ИНВАРИАНТ: A[1:K] < b && A[K+1:L] == b && A[M+1:N] > b
    while L < M 
        if A[L+1] == b
            L += 1
        elseif A[L+1] > b
            A[L+1], A[M] = A[M], A[L+1]
            M -= 1
        else # if A[L+1] < b
            L += 1; K += 1
            A[L], A[K] = A[K], A[L]
        end
    end
    return K, M+1 
    # 1:K и M+1:N - эти диапазоны индексов определяют ещё не 
    # отсортированные части массива A
end
```

13.    Инвариант цикла. Вычисление порядковых статистик и медианы массива методом Хоара

Инвариантом цикла (с предусловием) называют утверждение (предикат), зависящее от фазовых переменных цикла (т.е. переменнных, которые могут изменяться в теле цикла), имеющее значение "истина" как до начала цикла, так и после любого числа его повторений.

Пусть имеется числовой массив А. Его k-ой порядковой статистикой называется значение k-го элемента этого массива, которое получилось бы после реализации процедуры сортировки массива A.

Если длина N массива нечетная, то его медианой называется порядковая статистика с индексом (N-1)/2. В случае же четной длины массива его медианой можно считать среднее арифметическое двух порядковых статистик с индексами N/2−1 и N/2+1.

```julia
function order_statistics!(A::AbstractVector{T}, i::Integer)::T where T
    function find(index_range)
        left_range, right_range = part_sort!(A, index_range, A[rand(index_range)])
        if i in left_range
            return find(left_range) 
        elseif i in right_range
            return find(right_range)
        else
            return A[i]
        end
    end
    find(firstindex(A):lastindex(A))
end

@inline function part_sort!(A, index_range::AbstractUnitRange, b)
    K, L, M = index_range[1]-1, index_range[begin]-1, index_range[end]
    @inbounds while L < M 
        if A[L+1] == b
            L += 1
        elseif A[L+1] > b
            A[L+1], A[M] = A[M], A[L+1]
            M -= 1
        else
            L += 1; K += 1
            A[L], A[K] = A[K], A[L]
        end
    end    
    return index_range[begin]:K, M+1:index_range[end]
end

function median(A::AbstractVector{T})
    if length(A)%2==0
        return order_statistics!(A, length(A)/2)
    else
        return (order_statistics!(A, length(A)/2)+order_statistics!(A, length(A)/2+1))/2
    end
end
```

14.    Вычисление первых k порядковых статистик O(N) (k ститать фиксированным и много меньшим N)
```julia
function minimums(array, k)
    N = length(array)
    k_minimums = sort(array[1:k])
    i = k
    while i < length(array)
        i += 1
        if array[i] < k_minimums[end]
            k_minimums[end] = array[i]
            insert_end!(k_minimums)
        end
    end
    return k_minimums
end            

function insert_end!(array)::Nothing
    j = length(array)
    while j>1 && array[j-1] > array[j]
        array[j-1], array[j] = array[j], array[j-1]
        j -= 1
    end
end
```

15.   Двунаправленная пузырьковая сортировка
```julia
function bubbleSortModS!(array::AbstractVector)
    counter = 0
    start = 2
    stop = length(array)-1
    step = 1
    for i in 1:(length(array)/2+1)
        for j in start:step:stop
            if step == 1
                if array[j] > array[j+step]
                    swap!(array, j, j+step)
                end
            end
            if step == -1
                if array[j] < array[j+step]
                    swap!(array, j, j+step)
                end
            end
        end
        if step == 1
            stop -= 1
        elseif step == -1
            start += 1
        end
        step = -step
        temp = start
        start = stop
        stop = temp
    end
end
```

16.  Сортировка Шелла
```julia
function shellSort!(array::AbstractVector)
    gap = length(array)
    while gap > 0
        for i in 1:lastindex(array)-gap
            j = i
            while j >= firstindex(a) && array[j] > array[j+gap]
                swap!(array, j, j+gap)
                j -= gap
            end
        end
        gap = div(gap, 2)
    end
end
```

17. Сортировка расчесыванием
```julia
function comb_sort!(array::AbstractVector)
    gap = length(array)
    while gap != 0
        for i in firstindex(array):lastindex(array)-gap
            if array[i] > array[i+gap]
                array[i], array[i+gap] = array[i+gap], array[i]
            end
        end
        gap-=1
    end
    return array
end
```

18. Сортировка слияниями
```julia
function merge_sort!(a)
    b = similar(a) 
    N = length(a)
    n = 1 
    while n < N
        K = div(N,2n) 
        for k in 0:K-1
            merge!(@view(a[(1:n).+k*2n]), @view(a[(n+1:2n).+k*2n]), @view(b[(1:2n).+k*2n]))
        end
        if N - K*2n > n
            merge!(@view(a[(1:n).+K*2n]), @view(a[K*2n+n+1:end]), @view(b[K*2n+1:end]))
        elseif 0 < N - K*2n <= n
            b[K*2n+1:end] .= @view(a[K*2n+1:end])
        end
        a, b = b, a
        n *= 2
    end
    if isodd(log2(n))
        b .= a 
        a = b
    end
    return a
end

function Base.merge!(a1, a2, a3)::Nothing
    i1, i2, i3 = 1, 1, 1
    @inbounds while i1 <= length(a1) && i2 <= length(a2)
        if a1[i1] < a2[i2]
            a3[i3] = a1[i1]
            i1 += 1
        else
            a3[i3] = a2[i2]
            i2 += 1
        end
        i3 += 1
    end
    if i1 > length(a1)
        a3[i3:end] .= @view(a2[i2:end])
    else
        a3[i3:end] .= @view(a1[i1:end])
    end
    nothing
end
```

19. Инвариант цикла. Быстрое возведение в степень

Инвариант цикла - это утверждение (предикат), зависящее от фазовых переменных цикла (т.е. переменнных, которые могут изменяться в теле цикла), имеющее значение "истина" как до начала цикла, так и после любого числа его повторений.

```julia
function quick_pow(a, deg)
    k, t, p = deg, 1, a

    while k>0
        if even(k)
            k ÷= 2
            p *= p
        else
            k -= 1
            t *= p 
        end   
    end
    return t
end
```

20.   Инвариант цикла. Приближенное вычисление логарифма (не используя разложения в ряд)

Инвариант цикла - это утверждение (предикат), зависящее от фазовых переменных цикла (т.е. переменнных, которые могут изменяться в теле цикла), имеющее значение "истина" как до начала цикла, так и после любого числа его повторений.

```julia
z, t, y = x, 1, 0
#ИНВАРИАНТ: a^y * z^t == x (=const)
while z > a || z < 1/a || t > ε   
    if z > a
        z /= a
        y += t # т.к. z^t = (z/a)^t * a^t
    elseif z < 1/a
        z *= a
        y -= t # т.к. z^t = (z*a)^t * a^-t
    else # t > ε
        t /= 2
        z *= z # т.к. z^t = (z*z)^(t/2)
    end
end
#УТВ: y: |log_a(x)-y| <= ε
```

21.  Инвариант цикла. Решение нелинейного уранения методом деления отрезка пополам.

Инвариант цикла - это утверждение (предикат), зависящее от фазовых переменных цикла (т.е. переменнных, которые могут изменяться в теле цикла), имеющее значение "истина" как до начала цикла, так и после любого числа его повторений.

```julia
function bisect(f::Funcnion, a, b, ε)
    y_a=f(a)
    #ИНВАРИАНТ: f(a)*f(b) < 0 (т.е. (a,b) - содержит корень)
    while b-a > ε
        x_m = (a+b)/2
        y_m=f(x_m)
        if y_m==0
            return x_m
        end
        if y_m*y_a > 0 
            a=x_m
        else
            b=x_m
        end
    end
    return (a+b)/2
end
```

22.  Инвариант цикла. Расширенный алгоритм Евклида вычисления НОД

Инвариант цикла - это утверждение (предикат), зависящее от фазовых переменных цикла (т.е. переменнных, которые могут изменяться в теле цикла), имеющее значение "истина" как до начала цикла, так и после любого числа его повторений.

```julia
# m, n - заданные целые
a, b = m, n
u_a, v_a = 1, 0
u_b, v_b = 0, 1
#=
ИНВАРИАНТ: 
    НОД(m,n)==НОД(a,b)
    a = u_a*m + v_a*n 
    b = u_b*m + v_b*n
=#
while b != 0
    k = a÷b
    a, b = b, a % b 
    #УТВ: a % b = a-k*b - остаток от деления a на b
    u, v = u_a, v_a
    u_a, v_a = u_b, u_a
    u_b, v_b = u-k*u_b, v-k*v_b
end
#УТВ: b == НОД(m,m) == u_a*m + v_a*n

function gcd_ext(m::T1, n::T2) where{T1, T2}
    #ax + by = 1    
    a, b = m, n
    u_a, v_a = 1, 0
    u_b, v_b = 0, 1
    a = u_a * m + v_a * n 
    b = u_b * m + v_b * n
    while b != 0
        k = a ÷ b
        a, b = b, a % b 
        u, v = u_a, v_a
        u_a, v_a = u_b, u_a
        u_b, v_b = u - k * u_b, v - k * v_b
    end
    return u_a
end
```

23.  Проверка, является ли число простым

```julia
function isprime_(n::T)::Bool where T <: Integer
    for i in 2:round(T, sqrt(n))
        if n % i == 0
            return false
        end
    end
    return true
end
```

24.  Вычисление всех простых чисел, не превосходящих заданного числа n методом решета Эратосфена 

```julia
function eratosphen(n::Integer)
    is_prime = ones(Bool, n) 
    is_prime[1] = false
    for i in 2:round(Int, sqrt(n))
        if is_prime[i] 
            for j in (i*i):i:n 
                is_prime[j] = false
            end
        end
    end
    return (1:n)[is_prime]
end
```

25.  Вычисление всех простых делителей числа и их кратностей

```julia
function divsAndTheirMultiple(n::Integer)
    primes = eratosphen(n)
    divs = []
    multiples = []
    for d in primes
        if n % d == 0
            push!(divs, d)
            push!(multiples, 0)
            while n%d==0
                n /= d
                multiples[length(multiples)] += 1 
            end
        end
    end
    return primes, multiples
end
```

26.  Приближенное решение нелинейного уравнения методом Ньютона. 

```julia
function newton(r::Function, x; epsilon = 1e-8, max_num_iter = 20)
    """Ищет корень уравнения f(x)=0
    r(x)= -f(x)/f'(x)
    x_0 - начальное приближение
    epsilon > 0 - пераметр, определяющий точность вычислений (критерий останова: |x - x_prev| = |r(x_prev)| <= epsilon)
    max_num_iter - максимальное число итераций"""
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

# f(x) = cos(x)-x
# f'(x) = -sin(x)-1
# r(x) = -f(x)/f'(x) = (cos(x)-x)/(sin(x)+1)
newton(x -> (cos(x)-x)/(sin(x)+1), 0.5)
```


27.  Применение метод Ньютона для приближенного вычисления комплексного корня многочлена

```julia
function polyval(P,x)
    dQ = 0
    Q = P[1]
    for i in 2:length(P)
        dQ = dQ*x + Q
        Q = Q*x + P[i]
    end
    return Q, dQ
end

#Фактический параметр функционального типа функции newton в данном случае может быть определён следующим образом:

# P - внешняя переменная, содержащая коэффициенты многочлена, следующих в порядке убывания степеней
function r(x)
    y, dy = polyval(P, x)
    return -y/dy
end
```

28. Проектирвание пользовательских типов. Пользовательский тип Polynomial{T} (частичная реализация методов)

```julia
struct Polynomial{T}
    coeff::Vector{T}

    function Polynomial{T}(coeff) where T 
        n = 0
        i = length(coeff)
        while coeff[i] == 0
            n += 1
            i -= 1
        end
        new(coeff[1:end-n])
    end
end

deg(p::Polinomial) = length(p.coeff) - 1

function Base. getindex(p::Polynomial{T}, i) where T
    return p.coeff[i]
end

function Base. length(p::Polynomial{T}) where T
    return length(p.coeff)
end

function Base. +(p::Polynomial{T}, q::Polynomial{T})::Polynomial{T} where T
    np, nq = length(p.coeff), length(q.coeff)
    if  np >= nq 
        coeff = similar(p.coeff)
        coeff[1:nq] .= (@view(p.coeff[1:nq]) .+ q) 
    else
        coeff = similar(q.coeff)
        coeff[1:np] .= (p .+ @view(q.coeff[1:np]))
    end
    i, n = lastindex(coeff), 0
    while i > 0 && coeff[i] == 0
        n += 1
        i -= 1
    end
    # n = число нулей в конце массива coeff, соответсвующих старшим степеням 
    resize!(coeff, length(coeff)-n)
    return Polynomial{T}(coeff)
end

Base. +(p::Polynomial{T}, c::T) where T = +(p, Polynomial{T}([c]))
Base. +(c::T, p::Polynomial{T}) where T = +(Polynomial{T}([c]), p)

Base. -(p::Polynomial{T}, c::T) where T = -(p, Polynomial{T}([c]))
Base. -(c::T, p::Polynomial{T}) where T = -(Polynomial{T}([c]), p)

Base. *(p::Polynomial{T}, c::T) where T = *(p, Polynomial{T}([c]))
Base. *(c::T, p::Polynomial{T}) where T = *(Polynomial{T}([c]), p)

function Base.display(p::Polynomial)
    if isempty(p.coeff)
        return ""
    end
    str = "$(p.coeff[1])" # $(...) - означает "интерполяцию стоки", т.е. вставку в строку некоторого вычисляемого значения 
    for i in 2:length(p.coeff)
        if i > 2
            s = " + $(p.coeff[i])x^$(i-1)"
        else
            s = " + $(p.coeff[i])x"
        end
        str *= s
    end
    println(str)
end
(p::Polynomial)(x) = polyval(reverse(p.coeff), x)
```

29. Проектирвание пользовательских типов. Пользовательский тип Polynomial{T}, реализация метода divrem

30. Проектирвание пользовательских типов. Пользовательский тип Reside{T,M}

```julia
struct Residue{T, M}
    value::T

    function Residue{T, M}(value) where {T, M}
        res = value % M
        if res < 0
            res += M
        end
        new(res) 
    end
end

function Base. +(a::Residue{T,M1}, b::Residue{T,M2}) where{T,M1,M2} 
    if M1==M2
        return Residue{T,M}(mod(a.value + b.value, M))
    end
    throw(Exception)
end

function Base. *(a::Residue{T,M1}, b::Residue{T,M2}) where{T,M1,M2} 
    if M1==M2
        return Residue{T,M}(mod(a.value * b.value, M))
    end
    throw(Exception)
end

Base. -(a::Residue{T,M}) where {T,M} = Residue{T,M}(M - a.value)

function Base. -(a::Residue{T,M1}, b::Residue{T,M2}) where{T,M1,M2} 
    if M1==M2
        return Residue{T,M}(a.value + M-b.value)
    end
    throw(Exception)
end

function Base.inv(a::Residue{T,M})::Union{Nothing, Residue{T,M}} where{T,M}
    if gcd(a.value, M)!=1
        return Nothing
    end

    return Residue{T,M}(ext_euclid(a.value, M))
end
```

31. Вычисление частичных сумм степенного ряда, заданного формулой n-го члена, построение соответсвующих графиков

```julia
using Plots

function eyler(n::Integer)
    s = 0.0
    a = 1.0
    
    for k in 1:n+1 
        s += a
        a /= k # границы значений индекса k по отношению к прежнему варианту теперь смещены на 1 вправо
    end
    
    return s
end

function draw()
    x1 = 0:0.1:20
    p1 = plot()
    for m in 1:5
        plot!(p1, x1, eyler.(m))
    end
    display(p1)
end
```

32. Численное суммирование степенного ряда с точностью до машинного эпсилон, заданного формулой n-го члена, построение соответсвующих графиков

```julia
```function sin(x, eps=1e-8)
    xx=x^2
    a=x
    m=2
    s=typeof(x)(0) 
    
    while abs(a) > eps
        s += a
        a = -a*xx / m / (m+1)
        m += 2
    end
    
    return s
end```

function Base.sin(x,ε)
    xx=x^2
    a=x
    m=2
    s=typeof(x)(0) #Преобразование к 0 нужного типа, что обеспечит стабильность типа переменной s
    while abs(a)>ε
        s+=a
        a=-a*xx/m/(m+1)
        m+=2
    end
    #УТВ: |sin(x)-s|<= ε
    return s
end

"""Возвращает значение n-ой частичной суммы ряда для cos(x) в точке х"""
function part_sum(n, x)
    xx = x^2
    a = 1
    m = 1
    s = 0 
    
    while (m-1)/2 < n
        s += a
        a = -a*xx / m / (m+1)
        m += 2
    end
    
    return s
end

function draw()
    x = 1:0.1:10
    p = plot()
    for n in 2:2:16
        plot!(p, x, part_sum.(n, x))
    end
    display(p)
end
```

33. Проектирвание пользовательских типов. Типданных Vector2D, обеспечивающий операции с векторами на плоскости, необходимые для решения задач по вычислительной геометрии, вычисление углов между прямыми (между направляющими векторами).

```julia
using LinearAlgebra

Vector2D{T<:Real} = NamedTuple{(:x, :y), Tuple{T,T}} #именованный кортеж, для этого типа можно определить псевдоним.

Base. +(a::Vector2D{T},b::Vector2D{T}) where T = Vector2D{T}(Tuple(a) .+ Tuple(b))

Base. -(a::Vector2D{T}, b::Vector2D{T}) where T = Vector2D{T}(Tuple(a) .- Tuple(b))

Base. *(α::T, a::Vector2D{T}) where T = Vector2D{T}(α .* Tuple(a))

LinearAlgebra.norm(a::Vector2D) = norm(Tuple(a)) #Base.
# norm(a) - длина вектора, эта функция определена в LinearAlgebra

LinearAlgebra.dot(a::Vector2D{T}, b::Vector2D{T}) where T = dot(Tuple(a), Tuple(b))
# dot(a,b)=|a||b|cos(a,b) - скалярное произведение, эта функция определена в LinearAlgebra

Base.cos(a::Vector2D{T}, b::Vector2D{T}) where T = dot(a,b)/norm(a)/norm(b)

Base.sin(a::Vector2D{T}, b::Vector2D{T}) where T = xdot(a,b)/norm(a)/norm(b)


xdot(a::Vector2D{T}, b::Vector2D{T}) where T = a.x*b.y - a.y*b.x
# xdot(a,b)=|a||b|sin(a,b) - косое произведение

Base.angle(a::Vector2D{T}, b::Vector2D{T}) where T = atan(sin(a,b),cos(a,b))

Base.sign(a::Vector2D{T}, b::Vector2D{T}) where T = sign(sin(a,b))
```

34. Задача вычисления координат точки пересечения (если она существует) двух отрезков на плоскости. Протестироват программу с построением графиков.

```julia
Segment2D{T<:Real} = NamedTuple{(:A, :B), NTuple{2,Vector2D{T}}} #Введём новый тип данных сегмент, задающийся двумя векторами

function intersect(s1::Segment2D{T},s2::Segment2D{T}) where T
    A = [s1.B[2]-s1.A[2]  s1.A[1]-s1.B[1]
         s2.B[2]-s2.A[2]  s2.A[1]-s2.B[1]]

    b = [s1.A[2]*(s1.A[1]-s1.B[1]) + s1.A[1]*(s1.B[2]-s1.A[2])
         s2.A[2]*(s2.A[1]-s2.B[1]) + s2.A[1]*(s2.B[2]-s2.A[2])]

    x,y = A\b #Если матрица A - вырожденная, то произойдет ошибка времени выполнения

    if isinner((;x, y), s1)==false || isinner((;x, y), s2)==false
        return nothing
    end

    return (;x, y) #Vector2D{T}((x,y))
end

isinner(P::Vector2D, s::Segment2D) = (s.A.x <= P.x <= s.B.x || s.A.x >= P.x >= s.B.x) && (s.A.y <= P.y <= s.B.y || s.A.y >= P.y >= s.B.y)
```

35.  Проверка, лежат ли две заданные точки по одну сторону от заданной прямой. Проверка, лежат ли две заданные точки по одну сторону от неявно заданной кривой. Протестироват программу с построением графиков.

s - сегмент рассматриваемой прямой
P, Q - точки
Определим направляющий вектор прямой l=AB. Тогда, точки P, Q лежат по одну сторону от прямой тогда и только тогда, когда угол между векторами l, AP и угол между векторами l, AQ имеют один и тот же знак (отложены в одну и ту же сторону от прямой).

```julia
function is_one(P::Vector2D{T}, Q::Vector2D{T}, s::Segment2D{T}) where T 
    l = s.B-s.A
    return sin(l, P-s.A)*sin(l,Q-s.A)>0
end
```

36.  Задача определения, является ли заданный плоский многоугольник выпуклым. Протестироват программу с построением графиков.

```julia
"""Структоура полигона (многоугольника)"""
struct Polygon{T} <: AbstractPolygon{T}
    vertices::Vector{Vector2D{T}}
    Polygon{T}(vertices) where {T} = new(double_ended!(vertices))
end

"""Дублирует в конце вектора его первый элемент, если изначально этого дублирования не было"""
function double_ended!(vertices::Vector{Vector2D})
    if vertices[begin] != vertices[end]
        push!(vertices, polygon[begin])
    end
    return vertices
end

get_vertices(polygon::Polygon) = polygon.vertices
num_vertices(polygon::Polygon) = polygon.vertices[begin] != polygon.vertices[end] ? length(polygon.vertices) : length(polygon.vertices) - 1

"""Структура выпуклого полигона"""
struct ConvexPolygon{T} <: AbstractPolygon{T}
    vertices::Vector{Vector2D{T}}
    ConvexPolygon{T}(vertices) where {T} = new(double_ended!(vertices))
end
get_vertices(polygon::ConvexPolygon) = polygon.vertices

Plots.plot!(polygon::AbstractPolygon; kwargs...) = plot!(current(), polygon.vertices; kwargs...)
Plots.plot!(p::Plots.Plot, polygon::AbstractPolygon; kwargs...) = plot!(p, polygon.vertices; kwargs...)
Plots.plot(polygon::AbstractPolygon; kwargs...) = plot(polygon.vertices; kwargs...)
```

37. Задача определения, лежит ли заданная точка плоскости внутри заданного выпуклого многоугольника. Протестироват программу с построением графиков.

```julia
function isinner(A::Vector2D{T}, polygon::ConvexPolygon{T})::Bool where T
    flag = double_ended!(polygon)
    sign_prev = sign(polygon[begin+1]-A, polygon[begin]-A)
    for i in firstindex(polygon.vertices)+1:lastindex(polygon.vertices)-1
        sign_cur += sign(polygon[i+1]-A, polygon[i]-A)
        if sign_prev * sign_cur < 0
            return false
        end 
    end
    if flag == true
        single_ended!(polygon)
    end
    return true
end

function double_ended!(polygon::AbstractPolygon)::Bool # дублирует в конце вектора его первый элемент, если изначально этого дублирования не было
    if polygon[begin] != polygon[end]
        push!(polygon, polygon[begin])
        return true # входной вектор изменён
    end
    return false # входной вектор не изменён 
end

function single_ended!(polygon::AbstractPolygon)::Bool # удаляет из конца вектора элемент, дублирующий первый, если такой элемент был
    if polygon[begin] == polygon[end]
        pop!(polygon)
        return true # входной вектор изменён
    end
    return false # входной вектор не изменён 
end
```

38. Проверка, лежит ли заданная точка плоскости внутри заданного многоугольника, не обязательно выпуклого. Протестироват программу с построением графиков.
    
```julia
function isinner(A::Vector2D{T}, polygon::AbstractPolygon{T})::Bool where {T}
    sum_angles = 0.0
    for i in firstindex(polygon.vertices):lastindex(polygon.vertices)-1
        sum_angles += angle(polygon[i+1] - A, polygon[i] - A)
    end
    return sum_angles < pi
end
```

39. Написать функцию, реализующую алгоритм Джарвиса построения выпуклой оболочки заданных точек плоскости. Протестироват программу с построением графиков.

```julia
function jarvis(points::Vector{Vector2D{T}})::ConvexPolygon{T} where T<:Real # алгоритм Джарвиса построения выпуклой оболочки заданного множества точек плоскости
    @assert length(points) > 1 # иначе операция в строке 9 будет не возможна
    # yyy = [points[i][2] for i in 1:length(points)] # - так создавался бы дополонительный массив
    yyy = (points[i][2] for i in 1:length(points))  # - а так массив не создается, вместо массива используется генератор
    i_start = findmin(yyy) # индекс самой нижней точки
    convex_shell = [i_start]
    ort_base = Vector2D{Int}((1,0)) # - этот вектор задает начальное базовое направление (горизонтално вправо)
    while next!(convex_shell, points, ort_base) != i_start
        ort_base = convex_shell[end] - convex_shell[end-1]  # - не нулевой вектор, задающий очередное базовое направление
    end
    return convex_shell # В конце и в начале массива convex_shell дважды содержится значение i_start 
end

function next!(convex_shell::Vector{Int64}, points::Vector{Vector2D{T}}, ort_base::Vector2D{T}) where T<:Real
    cos_max = typemin(T)
    i_base = convex_shell[end]
    resize!(convex_shell, length(convex_shell)+1)
    for i in eachindex(points)
        if points[i] == points[i_base] # тут не обязательно, что i == i_base
            continue
        end
        ort_i = points[i] - points[i_base] # - не нулевой вектор, задающий направление на очередную точку
        cos_i = cos(ort_base, ort_i)
        if cos_i > cos_max
            cos_max = cos_i
            convex_shell[end] = i 
        elseif cos_i == cos_max && quad_len(ort_i) > quad_len(ort_base) # на луче, содержащем сторону выпуклого многоугольника, может оказаться более двух точек заданного множества (надо выбрать самую дальнюю из них)
            convex_shell[end] = i
        end
    end
    return convex_shell[end]
end

quad_len(vec) = dot(vec, vec)
```

40. Написать функцию, реализующую алгоритм Грехома построения выпуклой оболочки заданных точек плоскости. Протестироват программу с построением графиков.

```julia
function grekhom!(points::Vector{Vector2D{T}})::ConvexPolygon{T} where {T<:Real}
    ydata = (points[i][2] for i in 1:length(points))
    i_start = findmin(ydata)
    points[begin], points[i_start] = points[i_start], points[begin]
    sort!(@view(points[begin+1:end]), by=(point -> angle(point, Vector2D{T}(1, 0))))
    push!(points, points[begin])
    convex_polygon = [firstindex(points), firstindex(points) + 1, firstindex(points) + 2]
    for i in firstindex(points)+3:lastindex(points)
        while sign(points[i] - points[convex_polygon[end]], points[convex_polygon[end-1]] - points[convex_polygon[end]]) < 0
            pop!(convex_polygon)
        end
        push!(convex_polygon, i)
    end
    pop!(points)
    return ConvexPolygon{T}(points[convex_polygon])
end
```

41. Написать функцию, возвращающую значение ориентированной площади заданного плоского многоугольника, воспользовавшись методом трапеций. Протестировать программу с построением графиков.

```julia
function orinet_sq_trap(poly::Polygon{T}) where {T<:Real}
    res = 0.0
    for i in firstindex(poly.vertices):lastindex(poly.vertices)-1
        res += (poly.vertices[i].y + poly.vertices[i+1].y) * (poly.vertices[i+1].x - poly.vertices[i].x) / 2
    end
    return res
end
```

42. Написать функцию, возвращающую значение ориентированной площади заданного плоского многоугольника, воспользовавшись методом треугольников. Протестировать программу с построением графиков.

```julia
function orient_sq_triangle(poly::Polygon{T}) where {T<:Real}
    res = 0.0
    for i in firstindex(poly.vertices)+1:lastindex(poly.vertices)-1
        res += xdot(poly.vertices[i] - poly.vertices[0], poly.vertices[i+1] - poly.vertices[0])
    end
    return res
end
```

43. Пусть имеется некоторый выпуклый многоугольник (выпуклая оболочка некотрого множества точек плоскости) и дана ещё дна тока. Требуется написать функцию, строющую выпуклую оболочку множества точек, включающее также и эту новую точку. Протестировать программу с построением графиков.

```julia
function add_point(conv::ConvexPolygon{T}, p::Vector2D{T}) where {T<:Real}
    if (length(conv.vertices) < 3)
        push!(conv.vertices(p))
        return conv
    end
    if !isinner(p, conv)
        min_angle = -10
        max_angle = 10
        max_ind = 1
        min_ind = 1
        for i in 1:length(conv.vertices)
            if angle(conv.vertices[i], p) >= max_angle
                max_angle = angle(conv.vertices[i], p)
                max_ind = i
            elseif angle(conv.vertices[i], p) <= max_angle
                min_angle = angle(conv.vertices[i], p)
                min_ind = i
            end
        end
        i = 0
        res = ConvexPolygon{T}()
        while i < min(min_ind, max_ind)
            push!(res.vertices, conv.vertices[i])
        end
        push!(res.vertices, p)
        i = max(min_ind, max_ind)
        while i < length(conv.vertices)
            push!(res.vertices, conv.vertices[i])
        end
        conv = res
        return res
    end
    return nothing
end
```

44. Написать функцию, проверяющую, явлется ли заданная последовательность точек (пердставленная типом Vector{Vector2D}), вершинами некоторого многоугольника (у многоугольника никакие две его стороны не пересекаются внутренним образом). Протестировать программу с построением графиков.

```julia
function is_poly(points::Vector{Vector2D{T}}) where {T}
    for i in 1:length(points)-1
        f = Segment2D{T}(points[i], points[i+1])
        for j in 1:i-1
            s = Segment2D{T}(points[j], points[j+1])
            if !isnothing(intersect(f, s))
                return false
            end
        end
    end
    return true
end
```

**Указание.** Воспользоваться ранее написанной функцией intersect, возвращающей координаты точки пересечения двух отрезков, если такая точка существует. При отсутствии точки пересечения функция возвращае или noting, или при её выполнении возникнет исключительная ситуации, если отрезки лежат на параллельных прямых. Эту возможную исключительную ситуацию следует перехватывать с помощью конструкции try-cath-end). Но прежде чем вызывать функцию intersect, следует проверить, являются ли в заданной последовательности точек все точки уникальными (в противном случае они заведомо не могут быть вершинами никакого многоугольника).

45. Написать функцию, вычисляющую выпуклую оболочку объединения некоторых двух множест точек плоскости, если заданы выпуклые оболочки каждого из них (сами множества считаются не заданными). Протестировать программу с построением графиков.

```julia
function unite(f::ConvexPolygon{T}, s::ConvexPolygon{T}) where {T}
    res = f
    for new_point in s.vertices
        add_point(res, new_point)
    end
    return res
end
```

46. Написать функцию, вычисляющую выпуклую оболочку пересечения каких-либо двух множеств точек плоскости, если заданы выпуклые оболочки каждого из них (сами множества считаются не заданными). Протестировать программу с построением графиков.

```julia
function unite(f::ConvexPolygon{T}, s::ConvexPolygon{T}) where {T}
    res = f
    for new_point in s.vertices
        add_point(res, new_point)
    end
    return res
end
```

47. Генерирование всех размещений с повторениями из n элементов {1,2,...,n} по k в лексикографическом порядке. Проектирвание пользовательских типов данных, итераторы.

48. Генерация вcех перестановок 1,2,...,n в лексикографическом порядке. Проектирвание пользовательский типов данных, итераторы.

49. Генерация всех всех подмножеств n-элементного множества {1,2,...,n} в лексикографическом порядке. Проектирвание пользовательских типов данных, итераторы.

50. Генерация всех всех k-элементных подмножеств n-элементного множества {1,2,...,n} в лексикографическом порядке. Проектирвание пользовательских типов данных, итераторы.

51. Генерирование всех размещений без повторений из n элементов {1,2,...,n} по k в лексикографическом порядке. Проектирвание пользовательских типов данных, итераторы.

52. Генерация всех разбиений натурального числа на положительные слагаемые. Проектирвание пользовательских типов данных, итераторы.

53. Решение задачи коммивояжера полным перебором для полного графа, заданного весовой матрицей.

54. Проверка, является ли заданный матрицей смежности граф гамильтоновым. (Указание: нули в матрице смежности заменить бесконечностями, и, считая полученную матрицу весовой, решить задачу коммивояжера).