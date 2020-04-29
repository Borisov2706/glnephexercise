clear all; clc; close all;
format long g

%���������
ae=6378136;         %������� (��������������) ������� ����������� ����������
we=0.7292115*10^-4; %earth's rotation rate

%������ �� RTKNAVI

x0=10192674.32;
y0=-12367565.43;
z0=19866879.39;
vx=2599.78676;
vy=-789.66141;
vz=-1827.75784;
ax=0.0000019;
ay=0.000009;
az=-0.0000028;
Tau=-38310; %ns
Gamma=0.0018; %ns
%%
%time format
 %2020.02.10 13.45.18           !!!!���������!!!!!
 N4=7;
 Nt=41;
 hour=13;
 min=45;
 sec=18;
 h_st=12;   %������ ����������, �����
 h_fin=24;  %����� ����������, �����
 
TIME=time(N4,Nt,hour,min,sec, h_st,h_fin);
S=TIME(1);
    time_start=TIME(2);
    time_final=TIME(3);
T=TIME(4);
te=TIME(5);
GMST=TIME(6);
time_final- time_start

%%
%Coordinates transformation to an inertial reference frame:

%Position
xa=x0*cos(S)-y0*sin(S);
ya=x0*sin(S)+y0*cos(S);
za=z0;
%Velocity
vxa=vx*cos(S)-vy*sin(S)-we*ya;
vya=vx*sin(S)+vy*cos(S)+we*xa;
vza=vz;

Jsm_x=ax*cos(S)-ay*sin(S);
Jsm_y=ax*sin(S)+ay*cos(S);
Jsm_z=az;

%%
%��������

coordinat=math(xa,ya,za,vxa,vya,vza,Jsm_x,Jsm_y,Jsm_z,time_start,time_final, te,T);

%������ �����

[EAR_x,EAR_y,EAR_z] = sphere(20);
EAR_x=ae.*EAR_x;
EAR_y=ae.*EAR_y;
EAR_z=ae.*EAR_z;
%�������
figure (1)
surf(EAR_x,EAR_y,EAR_z)
hold on
grid on
plot3(coordinat(:,1),coordinat(:,2),coordinat(:,3))
title('���������� �� � ������������ ��')
xlabel('x,km')
ylabel('y,km')
zlabel('z,km')

% ��� �������� � �� 90.11
ti=coordinat(:,7);

S_pz=GMST+we*(ti-10800);

x_pz=coordinat(:,1).*cos(S_pz)+coordinat(:,2).*sin(S_pz);
y_pz=-coordinat(:,1).*sin(S_pz)+coordinat(:,2).*cos(S_pz);
z_pz=-coordinat(:,3);

vx_pz=coordinat(:,4).*cos(S_pz)+coordinat(:,5).*sin(S_pz)+we*coordinat(:,2);
vy_pz=-coordinat(:,4).*sin(S_pz)+coordinat(:,5).*cos(S_pz)+we*coordinat(:,1);
vz_pz=-coordinat(:,6);
figure (2)
surf(EAR_x,EAR_y,EAR_z)
hold on
grid on
plot3(x_pz,y_pz,z_pz)
title('���������� �� � �� ��-90')
xlabel('x,km')
ylabel('y,km')
zlabel('z,km')

%% �������������� ���������� ������� � � �� ������� � ������� WGS-84
N_gr = 55;
N_min = 45;
N_sec = 23.5859;
E_gr = 37;
E_min = 42;
E_sec = 11.5030;
H = 150;% ������ � ������
N = N_gr*pi/180 + N_min/3437.747 + N_sec/206264.8; % ������ � ��������
E = E_gr*pi/180 + E_min/3437.747 + E_sec/206264.8; % ������� � ��������
llh = [N E H];
%PRM_coor = llh2xyz(llh)';

coordinat = coordinat(:,1:3).*1e3; % ������� � ������
 
 %% ����������� SkyPlot
for i=1:length(coordinat(:,1))
    [x(i), y(i), z(i)] = ecef2enu(coordinat(i,2),coordinat(i,2),coordinat(i,3),N,E,H,wgs84Ellipsoid,'radians');
    if z(i) > 0
     teta(i) = atan2(sqrt(x(i)^2 + y(i)^2),z(i));
     r(i) = sqrt(x(i)^2 + y(i)^2 + z(i)^2);
     phi(i) = atan2(y(i),x(i));
     else teta(i) = NaN;
     r(i) = NaN;
     phi(i) = NaN;
    end
end




figure(4);
polar(phi,(teta*180-pi)/pi,'r')
title('Sky PLot �� 13 �������')

ti=rot90(ti,1);

xti=[ti; x];
xti(:,1:200);

xti(: ,6318-15: 6318+15)
