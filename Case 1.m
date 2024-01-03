clc
clear all
inf=1e-14;
%IS=initial stiffness
%PS=plastic stiffness
%YS=yield strength
%US=ultimate strength
%FD=displacement at fracture
Ks=[IS,PS,YS,US,FD];
Kt=[IS,PS,YS,US,FD];
Kb=[IS,PS,YS,US,FD];
Kbs=[IS,PS,YS,US,FD];
Ks1=Ks(1);
Kt1=Kt(1);
Kb1=Kb(1);
Kbs1=Kbs(1);
k=1/(1/Kbs1+1/Kb1+1/Kt1/2+1/Ks1/2);

force=zeros(1,100000);
dis=zeros(1,100000);
a=1;

d=1;
e=1;
cornerd=0;
fs=0;
ft=0;
fbs=0;
fb=0;
f=0;
dertakb=0;
dertaks=0;
dertakt=0;
dertakbs=0;
dderta=0.1;
for derta=0.01:0.01:20

    %displacement increment of each rigid bar
    dderta=derta-cornerd; %bar 1
    
    %total force
    df=k*dderta;
    f=f+df;
    
    %displacement increment for each component
    ddertakbs=df/Kbs1;%bolts in shear
    ddertakb=df/Kb1;%plates in bearing
    ddertakt=df/2/Kt1;%plates in tension
    ddertaks=df/2/Ks1;%plates in shear

    %displacement for each component
    dertakbs=dertakbs+ddertakbs;%bolts in shear
    dertakb=dertakb+ddertakb;%plates in bearing  
    dertaks=dertaks+ddertaks;%plates in shear
    dertakt=dertakt+ddertakt;%plates in tension
    
    %load increment for each component
    dfbs=ddertakbs*Kbs1;%plates in shear
    dfb=ddertakb*Kb1;%tension spring    
    dfs=ddertaks*Ks1;%plates in shear
    dft=ddertakt*Kt1;%tension spring
    %load in each spring 
    fbs=fbs+dfbs;%bolts in shear
    fb=fb+dfb;%plates in bearing
    fs=fs+dfs;%shear spring
    ft=ft+dft;%tension spring

    %stiffness for each component
    %%plates in tension
    if ft>Kt(3)
        Kt1=Kt(2);
        if ft>Kt(4)
            Kt1=inf;
        end
    end
    %%plates in shear
    if fs>Ks(3)
        Ks1=Ks(2);
        if fs>Ks(4)
            Ks1=inf;
        end
    end 
    %%plates in bearing
    if fb>Kb(3)
        Kb1=Kb(2);
        if fb>Kb(4)
            Kb1=inf;
        end
    end  
    %%bolts in shear
    if fbs>Kbs(3)
        Kbs1=Kbs(2);
        if fbs>Kbs(4)
            Kbs1=inf;
        end
    end  
    
    %capacity reduce
    if dertaks>Ks(5)
        if e<2
        f=f-2*Ks(4);
        e=e+1;
        end
    end   
    if dertakt>Kt(5)
       if e<2
       f=f-2*Kt(4);
       e=e+1;
       end
    end   
    if dertakbs>Kbs(5)
        if e<2
        f=f-2*Kbs(4);
        e=e+1;
        end
    end   
    if dertakb>Kb(5)
       if e<2
       f=f-2*Kb(4);
       e=e+1;
       end
    end   
    
    cornerf=f;
    cornerd=derta;
    dis(1,d)=derta;
    force(1,d)=f;
    d=d+1;
    k=1/(1/Kbs1+1/Kb1+1/Kt1/2+1/Ks1/2);
end

plot(dis,force);       