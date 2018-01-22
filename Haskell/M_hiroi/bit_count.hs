import Data.Bits

bitCount::Int->Int
bitCount 0=0
bitCount n=1+bitCount (n .&. (n-1))

bitCount'::Int->Int
bitCount' n=(d .&. 0xffff)+shiftR d 16 where
  a=(n .&. 0x55555555) + ((shiftR n 1) .&. 0x55555555)
  b=(a .&. 0x33333333) + ((shiftR a 2) .&. 0x33333333)
  c=(b .&. 0x0f0f0f0f) + ((shiftR b 4) .&. 0x0f0f0f0f)
  d=(c .&. 0x00ff00ff) + ((shiftR c 8) .&. 0x00ff00ff)
