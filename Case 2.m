clc
clear all
inf=1e-14;
%stiffness and strength for each spring
%IS=initial stiffness
%PS=plastic stiffness
%YS=yield strength
%US=ultimate strength
%FD=displacement at fracture

Ks=[IS,PS,YS,US,FD];
Kt11=[IS,PS,YS,US,FD];
Kt22=[IS,PS,YS,US,FD];
Kbs=[IS,PS,YS,US,FD];
Kb=[IS,PS,YS,US,FD];
%

%initial stiffness for each spring
Ks1=Ks(1);
Ks2=Ks(1);
Kt1=Kt11(1);
Kt2=Kt22(1);
Kb1=Kb(1);
Kbs=Kbs(1);
%

%initial stiffness for specimen
k=1/(1/Kb1/2+1/Kbs/2+1/(2*Kt1*Ks1/(2*Ks1+Kt1)+2*Kt2*Ks2/(Ks2+Kt2)));
%
k
force=zeros(1,2590);
dis=zeros(1,2590);
d=1;
f=0;
ft1=0;
ft2=0;
fs1=0;
fs2=0;
fb=0;
fbs=0;
h=1;
j=1;
dt1=1;
dt2=1;
ds1=1;
ds2=1;
db=1;
dbs=1;
dertat1=0;
dertat2=0;
dertas1=0;
dertas2=0;
derta1=0;
derta2=0;
dertab=0;
dertabs=0;
cornerd=0;

for derta=0.01:0.01:30
    %force and force increment
    df=k*0.01;
    f=f+df;
    %displacement increment and displacement of bs and b
    ddertab=df/2/Kb1;
    ddertabs=df/2/Kbs;
    dertab=dertab+ddertab;
    dertabs=dertabs+ddertabs;
    %displacement increment of each rigid bar
    dderta=0.01-ddertab-ddertabs;
    dderta1=dderta*Kt1/(2*Ks1+Kt1);
    dderta2=dderta*Kt2/(Ks2+Kt2);
    %displacement of each rigid bar
    derta1=derta1+dderta1;
    derta2=derta2+dderta2;
    %displacement increment for each spring
    ddertat1=dderta-dderta1;
    ddertat2=dderta-dderta2;
    ddertas1=dderta1;
    ddertas2=dderta2;
    
    %displacement for each spring
    dertat1=dertat1+ddertat1;
    dertat2=dertat2+ddertat2;
    dertas1=dertas1+ddertas1;
    dertas2=dertas2+ddertas2;

    %load increment for each spring
    dfs1=ddertas1*Ks1;
    dfs2=ddertas2*Ks2;
    dft1=Kt1*ddertat1;
    dft2=Kt2*ddertat2;
    dfb=Kb1*ddertab;
    dfbs=Kbs*ddertabs;
    %force for each spring
    fs1=fs1+dfs1;
    fs2=fs2+dfs2;
    ft1=ft1+dft1;
    ft2=ft2+dft2;
    fb=dfb+fb;
    fbs=fbs+dfbs;
    %stiffness for each spring
    %%tension spring
    if ft1>Kt11(3)
        Kt1=Kt11(2);
                if h<2
            
            h=3;
        end
        if ft1>Kt11(4)
            Kt1=inf;
            dertat1=dertat1+dderta-ddertat1;
        end
    end
    if ft2>Kt22(3)
        Kt2=Kt22(2);

        if ft2>Kt22(4)
            Kt2=inf;
            dertat2=dertat2+dderta-ddertat2;
        end
    end 
    %%shear spring
    %%%convert displacement
    if fs1>Ks(3)
        Ks1=Ks(2);

        if fs1>Ks(4)
            Ks1=inf;
            dertas1=dertas1+dderta-ddertas1;
        end
    end 
    if fs2>Ks(3)
        Ks2=Ks(2);
        if fs2>Ks(4)
            Ks2=inf;
            dertas2=dertas2+dderta-ddertas2;
        end
    end  
    if fb>Kb(3)
        Kb1=Kb(2);
        if fb>Kb(4)
            Kb1=inf;
        end
    end  
    
    %fracture happen
    if dertat1>Kt11(5)
        if dt1<2
            f=f-Kt11(4);
            dt1=dt1+1;
        end
    end
    if dertat2>Kt22(5)
        if dt2<2
            f=f-2*Kt22(4);
            dt2=dt2+1;
        end
    end

    if dertas1>Ks(5)
        if ds1<2
            f=f-2*Ks(4);
            ds1=ds1+1;
        end
    end
    if dertas2>Ks(5)
        if ds2<2
            f=f-2*Ks(4);
            ds2=ds2+1;
        end
    end   
    
    cornerf=f;
    dis(1,d)=derta;
    force(1,d)=f;
    d=d+1;
    k=1/(1/Kb1/2+1/Kbs/2+1/(2*Kt1*Ks1/(2*Ks1+Kt1)+2*Kt2*Ks2/(Ks2+Kt2)));
end

plot(dis,force);    
          