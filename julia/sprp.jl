using oneAPI
N = 0x800_0000
#UInt32 is enough actually
#UInt32 would allow 2x more entries
#better to check 4k+3, 8k+5, ... order?
p = oneArray{UInt64}(3:2:N*2+1)
t = oneArray(ones(UInt64, N))
for i in 31:-1:1
    j = UInt64(1) << i
    t .*= (((p .& j) .!= 0) .+ 1)
    t .*= t;
    t .%= p;
    print("$i\n")
end
t .== 1