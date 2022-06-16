struct Residue{T, M}
    value::T
    Residue{T,M}(value) where {T,M} = new(mod(value, M)) 
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

Base. -(a::Residue{T,M}) where{T,M} = Residue{T,M}(M - a.value)

function Base. -(a::Residue{T,M1}, b::Residue{T,M2}) where{T,M1,M2} 
    if M1==M2
        return Residue{T,M}(a.value + M-b.value)
    end
    throw(Exception)
end

function ext_euclid(m::T1, n::T2) where{T1, T2}
    #ax + by = 1    
    a, b = m, n
    u_a, v_a = 1, 0
    u_b, v_b = 0, 1
    a = u_a*m + v_a*n 
    b = u_b*m + v_b*n
    while b != 0
        k = a÷b
        a, b = b, a % b 
        u, v = u_a, v_a
        u_a, v_a = u_b, u_a
        u_b, v_b = u-k*u_b, v-k*v_b
    end
    return u_a
end

function Base.inv(a::Residue{T,M})::Union{Nothing, Residue{T,M}} where{T,M}
    if gcd(a.value, M)!=1
        return Nothing
    end

    return Residue{T,M}(ext_euclid(a.value, M))
end

function Base. /(a::Residue{T,M1}, b::Residue{T,M2}) where{T,M1,M2} 
    if M1==M2
        return Residue{T,M}(a * inv(b))
    end
    throw(Exception)
end
Base. ==(a::Residue{T,M}, b::Residue{T,M}) where{T,M} = a.value == b.value
#Base. ===(a::Residue{T,M}, b::Residue{T,M}) where{T,M} = a.value === b.value
Base. >(a::Residue{T,M}, b::Residue{T,M}) where{T,M} = a.value > b.value
Base. <(a::Residue{T,M}, b::Residue{T,M}) where{T,M} = a.value < b.value
Base. <=(a::Residue{T,M}, b::Residue{T,M}) where{T,M} = a.value <= b.value
Base. >=(a::Residue{T,M}, b::Residue{T,M}) where{T,M} = a.value >= b.value

function Ris0(a::Residue{T,M}) where{T,M}
    return a.value==Int64(0)
end

struct Polynomial{T}
    coeff::Vector{T}
    function Polynomial{T}(coeff) where T 
        n = 0
        for c in reverse(coeff)
            if c == 0
                n+=1
            end
        end
        new(coeff[1:end-n])
    end
end

deg(p::Polynomial) = length(p.coeff) - 1

function remove_zeros(p::Polynomial{T}) where T
    coeff = copy(p.coeff)
    i, n = lastindex(coeff), 0
    while i > 0 && coeff[i] == 0
        n += 1
        i -= 1
    end
    resize!(coeff, length(coeff)-n)
    return Polynomial{T}(coeff)
end

function Base. +(p::Polynomial{T}, q::Polynomial{T})::Polynomial{T} where T
    np, nq = length(p.coeff), length(q.coeff)
    if  np >= nq 
        coeff = similar(p.coeff)
        coeff[1:nq] .= (@view(p.coeff[1:nq]) .+ q.coeff) 
    else
        coeff = similar(q.coeff)
        coeff[1:np] .= (p.coeff .+ @view(q.coeff[1:np]))
    end
    return remove_zeros(Polynomial{T}(coeff))
end

function Base. -(p::Polynomial{T}, q::Polynomial{T})::Polynomial{T} where T
    np, nq = length(p.coeff), length(q.coeff)
    if  np >= nq 
        coeff = similar(p.coeff)
        coeff[1:nq] .= (@view(p.coeff[1:nq]) .- q.coeff) 
    else
        coeff = similar(q.coeff)
        coeff[1:np] .= (p.coeff .- @view(q.coeff[1:np]))
    end
    # При сложении некоторые старшие коэфициенты могли обратиться в 0 
    return remove_zeros(Polynomial{T}(coeff))
end


function Base. *(p::Polynomial{T}, q::Polynomial{T})::Polynomial{T} where T
    coeff = zeros(T, deg(p) + deg(q)+1)
    for i in eachindex(p.coeff), j in eachindex(q.coeff)
            coeff[i+j - 1] += p.coeff[i]*q.coeff[j]
    end
    return remove_zeros(Polynomial{T}(coeff))
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
