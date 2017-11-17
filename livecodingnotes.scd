make a simple playbuf proxy

more fx - warp, filters,
drone sounds
noise sound sources

do a few live coding sessions

drone

cheat sheet

DynKlank

{|pch=60| DynKlank.ar(`[ [pch, pch+0.4, (pch.midicps*2).cpsmidi+0.25, (pch.midicps*2).cpsmidi+0.05, (pch.midicps*3).cpsmidi+0.5,  (pch.midicps*3).cpsmidi+0.3, (pch.midicps*4).cpsmidi+0.75, (pch.midicps*5).cpsmidi+1, (pch.midicps*6).cpsmidi+1.25, (pch.midicps*7).cpsmidi+1.5, (pch.midicps*8).cpsmidi+1.75, (pch.midicps*9).cpsmidi+2, (pch.midicps*10).cpsmidi+2.25, (pch.midicps*11).cpsmidi+2.5, (pch.midicps*12).cpsmidi+2.75, (pch.midicps*13).cpsmidi+3, (pch.midicps*14).cpsmidi+3.25, (pch.midicps*15).cpsmidi+3.5, (pch.midicps*16).cpsmidi+3.75, (pch.midicps*17).cpsmidi+4].midicps, nil, [0.51, 0.5, 0.5, 1,1,1,1,1,1,1,1,1,1,1,1,1,1] ], Impulse.ar(0.5)) }.play;
