#Сортировка Хоара(быстрая сортировка)
function quick_sort!(A)
    length(A) <= 1 &&  return A
    N = length(A)
    left, right = part_sort!(A, A[rand(1:N)]) # - "базовый" элемент массива выбирается случайнам образом
    quick_sort!(left) # передача среза по ссылке исключает лишние аллокоции (коприрования)
    quick_sort!(right)
    return A
end

function part_sort!(A, b)
    N = length(A)
    K, L, M = 0, 0, N
    #ИНВАРИАНТ: A[1:K] < b && A[K+1:L] == b && A[M+1:N] > b
    @inbounds while L < M # макрос @inbounds отменяет контроль выхода за пределы массива
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
    return K, M+1 # 1:K и M+1:N - эти диапазоны индексов определяют ещё не отсортированные части массива A
end

#Реализовать вычисление k-ой порядковой статистики методом Хоара (обеспечить сложность алгоритма O(n))
function order_statistics!(A, i)
    N = length(A)
    b = A[rand(1:N)]
    K, M = part_sort!(A, b) # - "базовый" элемент массива обычно выбирается случайным образом
    if K < i < M
        return A[i]
    elseif i <= K
        return order_statistics!(@view(A[1:K]), i) 
    else # i >= M
        return order_statistics!(@view(A[M:N]), i)
    end
end
order_statistics(A, i) = order_statistics!(copy(A), i)

#Реализовать вычисление медианы массива (основываясь на алгоитрме вычислениия порядеовых статистик)
function med(A)
    N = length(A)
    if mod(N, 2) == 0
        return (order_statistics!(A, N ÷  2) + order_statistics!(A, N ÷ 2 + 1))/2
    else
        return order_statistics!(A, N/2+1)
    end
end

#Реализовать поиск первых k наименьших элементов массива (k - фиксированное значение, от длины массива не зависящее). 
#Обеспечить сложность O(n), не используя процедуру Хоара.
function minimums(array, k)
    N = length(array)
    k_minimums = sort(array[1:k])
    i = k
    # ИНВАРИАНТ: issorted(k_mins) && k_mins - содержит k наименьших элементов в array[1:i]
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

#Реализовать однопроходный алгоритм вычисления среднего квадратического отклонения от среднего значения массива
function sd(A)
    s = 0
    s2 = 0
    c = 0
    for i in A
        c+=1
        s+=i
        s2+=i*i
    end
    return sqrt((s2+s^2/c-2*s*s/c)/c)
end
