Utils = Core.class()

function Utils:init()
    -- Key for XOR
    self.key = conf.SECRET_KEY
    
    self.XOR_l =
    { 
       {0,1},
       {1,0},
    }
end

function Utils:bytes_to_int(str, endian, signed) -- use length of string to determine 8,16,32,64 bits
    local t={str:byte(1,-1)}
    if endian=="big" then --reverse bytes
        local tt={}
        for k=1,#t do
            tt[#t-k+1]=t[k]
        end
        t=tt
    end
    local n=0
    for k=1,#t do
        n=n+t[k]*2^((k-1)*8)
    end
    if signed then
        n = (n > 2^(#t*8-1) -1) and (n - 2^(#t*8)) or n -- if last bit set, negative.
    end
    return n
end


function Utils:int_to_bytes(num, endian, signed)
    if num<0 and not signed then num=-num print"warning, dropping sign from number converting to unsigned" end
    local res={}
    local n = math.ceil(select(2,math.frexp(num))/8) -- number of bytes to be used.
    if signed and num < 0 then
        num = num + 2^n
    end
    for k=n,1,-1 do -- 256 = 2^8 bits per char.
        local mul=2^(8*(k-1))
        res[k]=math.floor(num/mul)
        num=num-res[k]*mul
    end
    assert(num==0)
    if endian == "big" then
        local t={}
        for k=1,n do
            t[k]=res[n-k+1]
        end
        res=t
    end
    return string.char(unpack(res))
end


function Utils:xor(a, b)
   pow = 1
   c = 0
   while a > 0 or b > 0 do
      c = c + (self.XOR_l[(a % 2)+1][(b % 2)+1] * pow)
      a = math.floor(a/2)
      b = math.floor(b/2)
      pow = pow * 2
   end
   return c
end


function Utils:readBestScoreFromFile()
    local best_score
    local file = io.open("|D|data.bin","r")
    if not file then
        print("Error: File not found")
    else
        best_score = file:read("*all")
       
        best_score = self:bytes_to_int(best_score)

        best_score = self:xor(best_score, self.key)
        
        file:close()
    end
    return best_score or 0
end


function Utils:writeBestScoreToFile(best_score)
    
    local file = io.open("|D|data.bin","wb+")

    -- XOR
    best_score = self:xor(best_score, self.key)

    best_score = self:int_to_bytes(best_score)

    file:write(best_score)
    file:close()
end