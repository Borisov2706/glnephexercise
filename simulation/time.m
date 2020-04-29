function [ time ] = time( N4,Nt,hour,min,sec, h_st,h_fin )
pi=3.14159265359;
we=0.7292115*10^-4; %earth's rotation rate
te=(hour+3)*60*60+min*60+sec;
time_start=(h_st+3)*60*60; %(+3 UTC)
time_final=(h_fin+3)*60*60;
% if (time_final>24*60*60)
%     time_final=time_final-24*60*60;
% end
C1=0;%use after 2119 year
C2=0;%use after 2239 year
JD0=1461*(N4-1)+Nt+2450082.5-(Nt-3)/25+C1+C2; %������� ��������� ���� �� 0 ����� ����� ���
T=(JD0+(te -10800)/86400-2451545.0)/36525;
%������� ������� ������ GMST � ������ (���������� � ���)
JDN=JD0+0.5;

Tdel=(JD0-2451545.0)/36525;
ERA=2*pi*(0.7790572732640+1.00273781191135448*(JD0-2451545.0));%���� �������� �����, ���
GMST=ERA+0.0000000703270726+0.0223603658710194*Tdel+0.0000067465784654*Tdel^2-0.0000000000021332*Tdel^3-0.0000000001452308*Tdel^4-0.0000000000001784*Tdel^5;   %�������� �������� ����� �� �������� (���) (GST ���)
S=GMST+we*(te-10800);  %10800 �� ���
[time]=[S,time_start,time_final,T,te,GMST] ;
end

