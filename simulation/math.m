function [math ] = math(xa,ya,za,vxa,vya,vza,Jsm_x,Jsm_y,Jsm_z,time_start,time_final, te,T)
%������ �� ��������.te=t_��������
%����: ������������� 4 ��������:
%1. ���������� ������������ � ���� �����,� t_��������< t_start- ��� ��� ������. ������ ������� ��
%t_start �� t_end � ����� dt/
%2.���������� ������������ � �����, �� t_start<t_��������. ���� ��� ����
%�������������. ��������� ��������� ������ ����� �� t�, ������� ���������
%[te-1, te-2, ... t_start+1, t_start] , �������������� ���, ����� ���������
%�� te �� t_end, ��������� ���������� � ����� � ���� ������, ������ � ���������, �����, ��
%���������
%3. ����������  �� ������������ � �����, �� t_��������< t_start. ���� ���
%���� ���������, ������ ������ �� t_start �� 24*60*60 � �� 0 �� t_end  �
%����� dt/ (������ ��������� �����, ���� t=[t_start, t_start+1,...24*60*60-1, 24*60*60,0,1,2,...,t_end])
%4. ���������� �� ������������ � ����� � t_start<t_��������. ����� �������
%�������, ��� ���� ��������� ��� ��� ������.������ ��������- �� te ��
%t_start (�� ������ �����������). ������- �� te �� 24*60*60, ����� �� 0 �� t_end. �������,
%���������, ������.
dt=1;
%%
%������ �������. 
if(te<=time_start&&te<time_final)
    t=time_start:dt:time_final-dt;
    result=nan(length(t),6);
    XA=zeros(length(t),1);
    XA(1,:)=xa;
    YA=zeros(length(t),1);
    YA(1,:)=ya;
    ZA=zeros(length(t),1);
    ZA(1,:)=za;
    VXA=zeros(length(t),1);
    VXA(1,:)=vxa;
    VYA=zeros(length(t),1);
    VYA(1,:)=vya;
    VZA=zeros(length(t),1);
    VZA(1,:)=vza;
    result=RungKUTT( t,dt,XA,YA,ZA,VXA,VYA,VZA, dt ); 
    ti=t;
    
    
 %������ �������
elseif(te>time_start&&te<time_final)
    %��� ��� ���� ����������� 2 ������: �� ���������� � �����. ������
    %��������� �� ���������� ���� ����� ���������, �.�. ��� ����� �����������
    %� �������� �������
    tbef=te:-dt:time_start;
    XAbef=zeros(length(tbef),1);
    XAbef(1,:)=xa;
    YAbef=zeros(length(tbef),1);
    YAbef(1,:)=ya;
    ZAbef=zeros(length(tbef),1);
    ZAbef(1,:)=za;
    VXAbef=zeros(length(tbef),1);
    VXAbef(1,:)=vxa;
    VYAbef=zeros(length(tbef),1);
    VYAbef(1,:)=vya;
    VZAbef=zeros(length(tbef),1);
    VZAbef(1,:)=vza;
    result_bef=RungKUTT( tbef,-dt,XAbef,YAbef,ZAbef,VXAbef,VYAbef,VZAbef, dt );
    
    %after
    taft=te+1:dt:time_final-dt;
    length(taft)
    XA=zeros(length(taft),1);
    XA(1,:)=xa;
    YA=zeros(length(taft),1);
    YA(1,:)=ya;
    ZA=zeros(length(taft),1);
    ZA(1,:)=za;
    VXA=zeros(length(taft),1);
    VXA(1,:)=vxa;
    VYA=zeros(length(taft),1);
    VYA(1,:)=vya;
    VZA=zeros(length(taft),1);
    VZA(1,:)=vza;
    result_after=RungKUTT( taft,dt,XA,YA,ZA,VXA,VYA,VZA, T );
    
    %�������!
    tbef=rot90(tbef,2);
  
   %result_before=rot90(result_bef,2);
    result_before=[rot90(result_bef(:,1),2) rot90(result_bef(:,2),2) rot90(result_bef(:,3),2) rot90(result_bef(:,4),2)  rot90(result_bef(:,5),2) rot90(result_bef(:,6),2)];
    result=[result_before;result_after];
    ti=[tbef taft];
 
    
 %������ �������
 elseif(te<=time_start&&te>time_final)
     %�� ��������
    t_24=time_start:dt:24*60*60-dt;
    result_24=nan(length(t_24),6);
    XA_24=zeros(length(t_24),1);
    XA_24(1,:)=xa;
    YA_24=zeros(length(t_24),1);
    YA_24(1,:)=ya;
    ZA_24=zeros(length(t_24),1);
    ZA_24(1,:)=za;
    VXA_24=zeros(length(t_24),1);
    VXA_24(1,:)=vxa;
    VYA_24=zeros(length(t_24),1);
    VYA_24(1,:)=vya;
    VZA_24=zeros(length(t_24),1);
    VZA_24(1,:)=vza;
    result_24=RungKUTT( t_24,dt,XA_24,YA_24,ZA_24,VXA_24,VYA_24,VZA_24, dt ); 
    
    %�� �������� �� t_end
     t_00=1:dt:time_final-dt;
    result_00=nan(length(t_00),6);
    XA_00=zeros(length(t_00),1);
    XA_00(1,:)=result_24(end,1);
    YA_00=zeros(length(t_00),1);
    YA_00(1,:)=result_24(end,2);
    ZA_00=zeros(length(t_00),1);
    ZA_00(1,:)=result_24(end,3);
    VXA_00=zeros(length(t_00),1);
    VXA_00(1,:)=result_24(end,4);
    VYA_00=zeros(length(t_00),1);
    VYA_00(1,:)=result_24(end,5);
    VZA_00=zeros(length(t_00),1);
    VZA_00(1,:)=result_24(end,6);
    result_00=RungKUTT( t_00,dt,XA_00,YA_00,ZA_00,VXA_00,VYA_00,VZA_00, dt ); 
    result=[result_24;result_00];
    ti=[t_24 t_00];
    
 %��������� �������
 elseif(te>time_start&&te>time_final)
   %�� ������ �� ��������
   tbef=te:-dt:time_start+1;
    XAbef=zeros(length(tbef),1);
    XAbef(1,:)=xa;
    YAbef=zeros(length(tbef),1);
    YAbef(1,:)=ya;
    ZAbef=zeros(length(tbef),1);
    ZAbef(1,:)=za;
    VXAbef=zeros(length(tbef),1);
    VXAbef(1,:)=vxa;
    VYAbef=zeros(length(tbef),1);
    VYAbef(1,:)=vya;
    VZAbef=zeros(length(tbef),1);
    VZAbef(1,:)=vza;
    result_bef=RungKUTT( tbef,-dt,XAbef,YAbef,ZAbef,VXAbef,VYAbef,VZAbef, dt );
    tbef=rot90(tbef,2);
    result_before=rot90(result_bef,2);
     %�� �������� �� ��������
    t_24=te:dt:24*60*60-1;
    
    XA_24=zeros(length(t_24),1);
    XA_24(1,:)=xa;
    YA_24=zeros(length(t_24),1);
    YA_24(1,:)=ya;
    ZA_24=zeros(length(t_24),1);
    ZA_24(1,:)=za;
    VXA_24=zeros(length(t_24),1);
    VXA_24(1,:)=vxa;
    VYA_24=zeros(length(t_24),1);
    VYA_24(1,:)=vya;
    VZA_24=zeros(length(t_24),1);
    VZA_24(1,:)=vza;
    result_24=RungKUTT( t_24,dt,XA_24,YA_24,ZA_24,VXA_24,VYA_24,VZA_24, dt ); 
    %�� �������� �� t_end
     t_00=1:dt:time_final-dt;
    result_00=nan(length(t_00),6);
    XA_00=zeros(length(t_00),1);
            XA_00(1,:)=result_24(end,1);
    YA_00=zeros(length(t_00),1);
            YA_00(1,:)=result_24(end,2);
    ZA_00=zeros(length(t_00),1);
            ZA_00(1,:)=result_24(end,3);
    VXA_00=zeros(length(t_00),1);
    VXA_00(1,:)=result_24(end,4);
    VYA_00=zeros(length(t_00),1);
    VYA_00(1,:)=result_24(end,5);
    VZA_00=zeros(length(t_00),1);
    VZA_00(1,:)=result_24(end,6);
    result_00=RungKUTT( t_00,dt,XA_00,YA_00,ZA_00,VXA_00,VYA_00,VZA_00, dt ); 
    %��� ���������
    result=[result_before;result_24;result_00];
    ti=[tbef t_24 t_00];
    
end
%%
%%�������� �� �������� ����
tau=ti-te;
tau=rot90(tau);
tpz=rot90(ti);
tpz=rot90(tpz,2);
NEB_TEL=sun_moon(T, xa,ya,za,vxa,vya,vza);

dx=Jsm_x*0.5*tau.^2; %(NEB_TEL(1)+(4))
dy=Jsm_y*0.5*tau.^2;
dz=Jsm_z*0.5*tau.^2;

dvx=Jsm_x*tau;
dvy=Jsm_y*tau;
dvz=Jsm_z*tau;

result(:,1)=result(:,1)+dx;
result(:,2)=result(:,2)+dy;
result(:,3)=result(:,3)+dz;

result(:,4)=result(:,4)+dvx;
result(:,5)=result(:,5)+dvy;
result(:,6)=result(:,6)+dvz;

[math]=[result tpz];
end

