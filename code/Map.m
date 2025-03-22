%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 混沌映射类型选择，label的1-6分别为tent、chebyshev
% tent、chebyshev、Singer、Logistic、Sine, Circle
% 调用函数生成并展示 tent 映射的图像

function result = Map( N, dim,label)

if label==1
        %chebyshev 映射
        chebyshev=5;
        Chebyshev=rand(N,dim);
        for i=1:N
            for j=2:dim
                Chebyshev(i,j)=cos(chebyshev.*acos(Chebyshev(i,j-1)));
            end
        end
        result = Chebyshev;

elseif label==2

        % Circle 映射
        a = 0.5; b=2.2;
        Circle=rand(N,dim);
        for i=1:N
            for j=2:dim
                Circle(i,j)=mod(Circle(i,j-1)+a-b/(2*pi)*sin(2*pi*Circle(i,j-1)),1);
            end
        end
        result = Circle;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif label==3
       % Gauss/mouse 混沌映射 
       Gauss = rand(N, dim);
       a=1;
       for i=1:N
           for j=2:dim
               if (Gauss(i,j-1)==0)
                   Gauss(i,j)=0;
               elseif Gauss(i,j-1)~=0
%                    Gauss(i,j)=a/mod(Gauss(i,j-1),1);
                   Gauss(i,j)=(rem(a/Gauss(i,j-1),1)) ;
                   %Gauss(i,j)=mod(a * Gauss(i,j-1) * (1 - Gauss(i,j-1)), 1);
               end
           end
       end
       result = Gauss;

elseif label==4
       % Piecewise 混沌映射
       P = 0.1;
       Piecewise = rand(N, dim);
       for i=1:N
           for j=2:dim
               if (Piecewise(i,j-1)<P) && (( Piecewise(i,j-1)>=0))
                   Piecewise(i,j)=Piecewise(i,j-1)/P;
               elseif (Piecewise(i,j-1)<0.5) && (( Piecewise(i,j-1)>=P))
                   Piecewise(i,j)=(Piecewise(i,j-1)-P)/(0.5-P);
               elseif (Piecewise(i,j-1)<(1-P)) && (( Piecewise(i,j-1)>=0.5))
                   Piecewise(i,j)=(1 - P - Piecewise(i,j-1))/(0.5-P);
               elseif (Piecewise(i,j-1)<1) && (( Piecewise(i,j-1)>=(1-P)))
                   Piecewise(i,j)=(1- Piecewise(i,j-1))/P;
               end
           end
       end
       result = Piecewise;
elseif label==5
       % Fuch 混沌映射
       Fuch = rand(N, dim);
       for i=1:N
           for j=2:dim
               Fuch(i,j)=cos(1/Fuch(i,j-1).^2);
           end
       end
       result = Fuch;
elseif label==6
       % Cubic混沌映射
       a = 2.595;
       Cubic = rand(N, dim);
       for i=1:N
           for j=2:dim
               Cubic(i,j)=a * Cubic(i,j-1) * (1-Cubic(i,j-1).^2);
           end
       end
       result = Cubic;
elseif label==7
       % ICMIC 混沌映射
       a = 10;
       ICMIC = rand(N, dim);
       for i=1:N
           for j=2:dim
               ICMIC(i,j)=sin(a/ICMIC(i,j-1));
           end
       end
       result = ICMIC;
elseif label==8
       % Tent-Logistic-Cosine混沌映射
       r=0.6;
       TLC = rand(N, dim);
       for i=1:N
           for j=2:dim
               if TLC(i, j-1) < 0.5
                   TLC(i,j)=cos(pi*(2 * r *TLC(i,j-1)+ 4*(1-r)*TLC(i,j-1)*(1-TLC(i,j-1)-0.5))); 
               else
                   TLC(i,j)=cos(pi*(2 * r *(1-TLC(i,j-1))+ 4*(1-r)*TLC(i,j-1)*(1-TLC(i,j-1)-0.5))); 
               end
           end
       end
       result = TLC;
elseif label==9
       % Sine-Tent-Cosine混沌映射
       r = rand;
       STC = rand(N, dim);
       for i=1:N
           for j=2:dim
               if STC(i, j-1) < 0.5
                   STC(i,j)=cos(pi*(r *sin(pi*STC(i,j-1))+ 2*(1-r)*STC(i,j-1)-0.5)); 
               else
                   STC(i,j)=cos(pi*(r *sin(pi*STC(i,j-1))+ 2*(1-r)*(1-STC(i,j-1))-0.5));  
               end
           end
       end
       result = STC;
elseif label==10
       % Logistic-Sine-Cosine混沌映射
       r = 0.5;
       LSC = rand(N, dim);
       for i=1:N
           for j=2:dim
               LSC(i,j)=cos(pi*(4*r*LSC(i,j-1)*(1-LSC(i,j-1))+(1-r)*sin(pi*LSC(i,j-1)-0.5)));
           end
       end
       result = LSC;
% elseif label==11
%        % Cubic混沌映射
%        a = 2.595;
%        Cubic = rand(N, dim);
%        for i=1:N
%            for j=2:dim
%                Cubic(i,j)=a * Cubic(i,j-1) * (1-Cubic(i,j-1).^2);
%            end
%        end
%        result = Cubic;
% elseif label==12
%        % Logistic-Tent 混沌映射
%        r = rand;
%        while r == 0 || r == 1
%              r = rand;
%        end
%        r = 4 * r;
%        LT = rand(N, dim);
%        for i=1:N
%            for j=2:dim
%                if LT(i, j-1)<0.5
%                   LT(i,j)=mod(r*LT(i,j-1)*(1-LT(i,j-1))+(4-r)*LT(i, j-1)/2,1);
%                else 
%                   LT(i,j)=mod(r*LT(i,j-1)*(1-LT(i, j-1))+(4-r)*(1-LT(i, j-1))/2,1);
%                end
%            end
%        end
%        result = LT;
% elseif label==13
%        % Bernoulli 混沌映射
%        a = 0.4; 
%        Bernoulli = rand(N, dim);
%        for i=1:N
%            for j=2:dim
%                if (Bernoulli(i,j-1)<=(1-a)) && (( Bernoulli(i,j-1)>0))
%                    Bernoulli(i,j)= Bernoulli(i,j-1)/(1-a);
%                elseif (Bernoulli(i,j-1)<=1) && (( Bernoulli(i,j-1)>(1-a)))
%                    Bernoulli(i,j)=(Bernoulli(i,j-1)-1+a)/a;
%                end
%            end
%        end
%        result = Bernoulli;
% elseif label==14
%        % Kent 混沌映射
%        a = 0.5; 
%        Kent = rand(N, dim);
%        for i=1:N
%            for j=2:dim
%                if (Kent(i,j-1)<=a) && (( Kent(i,j-1)>0))
%                    Kent(i,j)= Kent(i,j-1)/a;
%                elseif (Kent(i,j-1)<1) && (( Kent(i,j-1)>a))
%                    Kent(i,j)=(1 - Kent(i,j-1))/(1-a);
%                end
%            end
%        end
%        result = Kent;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    %无映射
   result =rand(N,dim);
end
end