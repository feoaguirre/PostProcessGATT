%%=============================FINITE=DIFERENCE=================================%%


function diff4orR = diff4orR(index,U,Y)

diff4or = ((-25*U(:,index)+48*U(:,index+1)-36*U(:,index+2)+16*U(:,index+3)-3*U(:,index+4))/(12*Y(index)));

end

function diff2orR = diff2orR(index,U,Y)

diff4or = ((-3*U(:,index)+4*U(:,index+1)-U(:,index+2))/(2*Y(index)));

end

function diff4orL = diff4orL(index,U,Y)

diff4or = ((25*U(:,index)-48*U(:,index+1)+36*U(:,index+2)-16*U(:,index+3)+3*U(:,index+4))/(12*Y(index)));

end

function diff2orL = diff2orL(index,U,Y)

diff4or = ((3*U(:,index)-4*U(:,index+1)+U(:,index+2))/(2*Y(index)));

end

function diff4orC = diff4orC(index,U,Y)

diff4or = ((-U(:,index+2)+8*U(:,index+1)-8*U(:,index-1)+U(:,index-2))/(12*Y(index)));

end
