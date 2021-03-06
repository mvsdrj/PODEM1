function F = estimateFundamentalMatrix(m1,m2)
[x,y] = size(m2);
a = zeros(y,9);
a(:,9)=1;
for i=1:y
    a(i,1)=m2(1,i)*m1(1,i);
    a(i,2)=m2(1,i)*m1(2,i);
    a(i,3)=m2(1,i);
    a(i,4)=m2(2,i)*m1(1,i);
    a(i,5)=m2(2,i)*m1(2,i);
    a(i,6)=m2(2,i);
    a(i,7)=m1(1,i);
    a(i,8)=m1(2,i);
end
[u,s,v] = svd(a);
p = v(:,9);
p = reshape(p,3,3);
%p=p/norm(p);
[u1,e1,v1] = svd(p);
e1(3,3) = 0;
F = u1*e1*v1';