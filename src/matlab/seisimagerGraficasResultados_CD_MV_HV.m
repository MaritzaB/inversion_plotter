close all; clear; clc;

% Para usar este programa hay que descargar de los resultados de seisimager
% el archivo phase velocity curve y guardarlo como txt, separarlo en excel
% con tabulación y espacio y guardarlo como txt. ES IMPORTANTE QUE NO HAYA
% ALGÚN ARCHIVO DIFERENTE A LA INFORMACIÓN A GRAFICAR EN LA CARPETA 
% DONDE SE ESTÁ TRABAJANDO, DE LO CONTRARIO EL PROGRAMA MARCARÁ UN ERROR
% DE DIMENSIONES. ESTO ES PARA CASOS DE MODELOS 1D.

% Si para evaluar un medio se utilizaron varias curvas de dispersión, deben
% agregarse individualmente para que el programa jale todos los datos y los
% muestre en la misma gráfica. ESTO ES SOLO PARA EL CASO DONDE SE PROCESA
% MASW PARA IMÁGENES 2D.

path = 'C:\Users\Angel\Documents\...'

folder = cd(path);

cabecera = 2; % Son los dos puntos, este valor no se mueve
modelosTotales = 4; %Este valor se cambia dependiendo de cuantas curvas se hayan invertido
lineas = cabecera + modelosTotales;
archivos=ls(folder);


j=1;
z=0;
for k = 3:lineas;
    z=z+1;
    longitudArchivo=importdata(archivos(k,:));
    [m,n] = size(longitudArchivo);
    p=z*n; j=p-(n-1);
    mv(k)=m;
    datos(1:m,j:p) = importdata(archivos(k,:));
end
mvdat=(mv(3:length(mv)));
% La primera linea da indicio de cuantos datos deben tomarse

numeroCapas = 15; % Modificar según el número de capas que se hayan usado
capasModelo = (numeroCapas * 2)-1;
p=0;j=2;
cdat = max(mvdat)-min(mvdat);

for i = 1:modelosTotales;
        curvasObservadas(1:datos(1,p+2),i) = datos(2:datos(1,2+p)+1,2+p);
        curvasCalculadas(1:datos(1,p+2),i) = datos(2:datos(1,2+p)+1,3+p);
        frecuencias(1:datos(1,p+2),i) = datos(2:datos(1,2+p)+1,4+p);
        
        r=1:mv(i+2)-(mv(i+2)-capasModelo);
        velocidad(r,i) = datos(mv(i+2)-capasModelo:mv(i+2)-1,p+3); 
        rp=1:mv(i+2)-(mv(i+2)-capasModelo);
        profundidad(rp,i) = datos(mv(i+2)-capasModelo:mv(i+2)-1,p+2); 
        p=p+n; j=j+1; 
end   

curvasObservadas(curvasObservadas==0) = NaN;
curvasCalculadas(curvasCalculadas==0) = NaN;
frecuencias(frecuencias==0) = NaN;

frecMax=(max(frecuencias));
frecuenciaMaxima=max(frecMax);
frecMin=(min(frecuencias));
frecuenciaMinima=min(frecMin);

velMaxC=(max(curvasObservadas));
velocidadMaximaC=max(velMaxC);
velMinC=(min(curvasObservadas));
velocidadMinimaC=min(velMinC);

velMax=(max(velocidad));
velocidadMaxima=max(velMax);
velMin=(min(velocidad));
velocidadMinima=min(velMin);


figure(1)
h1 = plot(curvasObservadas,frecuencias,'-- o r','LineWidth',1);
%title({'Curvas de dispersión';'Lineas 1 - 9'},'FontSize', 16); hold on
%title({'Curva de dispersión';'Línea 1'},'FontSize', 16); hold on
title({'Ajuste de la curva de dispersión';'MAM 04'},'FontSize', 16); hold on
h2 = plot(curvasCalculadas,frecuencias,'- k','LineWidth',1);
ax = gca;
ax.FontSize = 11;
axis([velocidadMinimaC-50 velocidadMaximaC+50 frecuenciaMinima-5 frecuenciaMaxima+5]);
set(gca,'XMinorTick','on','YMinorTick','on')
ylabel('Frecuencia [Hz]','FontSize', 17)
xlabel('Velocidad de fase [m/s]','FontSize', 17)
%legend([h1 h2],{'Curva observada','Curva calculada'})
view(90,-90); 

for i = 1:capasModelo
    modelovelocidadPromedio(i)=mean(velocidad(i,:));
end

figure(2)
plot(profundidad,velocidad,'LineWidth',1); %hold on
%plot(profundidad,modelovelocidadPromedio,'- k','LineWidth',2);
ax = gca;
ax.FontSize = 11;
axis([0 40 velocidadMinima-50 velocidadMaxima+50]) % Modificar solo el + o - para mostrar bien la gráfica
set(gca,'XMinorTick','on','YMinorTick','on')
ylabel('Velocidad de Onda S [m/s]','FontSize', 17)
xlabel('Profundidad [m]','FontSize', 17)
%title({'Modelos de velocidad';'MAM 1 - 4'},'FontSize', 16)
title({'Modelo de velocidad';'MAM 04'},'FontSize', 16)
%legend({'Línea 1','Línea 2','Línea 3','Línea 4','Línea 5','Línea 6','Línea 7','Línea 8','Línea 9'})
%legend({'MAM 01','MAM 02','MAM 03','MAM 04'})
legend({'MAM 04'})
view(90,90); 

figure(3)
plot(profundidad,modelovelocidadPromedio,'- k','LineWidth',2);
ax = gca;
ax.FontSize = 11;
axis([0 100 velocidadMinima-50 velocidadMaxima+50])
set(gca,'XMinorTick','on','YMinorTick','on')
ylabel('Velocidad de onda S [m/s]','FontSize', 17)
xlabel('Profundidad [m]','FontSize', 17)
title({'Modelo de velocidad promedio';'Lineas 1-9'},'FontSize', 16)
view(90,90); 

% Amplificación teórica
    frecAmp = datos(35:300,2); % Este valor de 30:130 debe ajustarse para la amp
    HV = datos(35:300,3); % Este valor también debe ajustarse, las muestras en frec y amp
    
% Todas las amplificaciones teóricas
j=2;
for i = 1:modelosTotales
    TfrecAmp(:,i) = datos(30:300,j);
    THV(:,i) = datos(30:300,j+1);
    j = j + 7;
end
frecMax=(max(frecAmp));
ampMaxima=max(HV);
frecMin=(min(frecAmp));
ampMinima=min(HV);

figure(4)
semilogx(TfrecAmp, THV, '-- o k');
title({'Amplificación Teórica';'MAM 04'},'FontSize', 16);
ax = gca;
ax.FontSize = 11;
axis([0.3  5.6 1 ampMaxima + 2])
set(gca,'XMinorTick','on','YMinorTick','on')
xlabel('Frecuencia [Hz]','FontSize', 17)
ylabel('H/V Teórico','FontSize', 17); 
%legend({'Línea 1, 1.07 Hz','Línea 2, 1.07 Hz','Línea 3, 1.17 Hz',...
%    'Línea 4, 1.07 Hz','Línea 5, 0.97 Hz','Línea 6, 1.07 Hz',...
%    'Línea 7, 1.27 Hz','Línea 8, 1.07 Hz','Línea 9, 1.07 Hz'})
ta = annotation('textarrow', [0.55 0.65], [0.7 0.65]);
elps.Color = [0 50 50];
ta.String = 'f_0 = 2.73 Hz';              
ta.Color = [0 .1 .1];
% ta = annotation('textarrow', [0.55 0.65], [0.7 0.4]);
% elps.Color = [0 50 50];
% ta.String = 'f_1 = 4 Hz';              
% ta.Color = [0 .1 .1]; 

% Cálculo de onda P

Vs = velocidad(:,:);
vd = [0.39,0.39,0.39,0,39,0.38,0.38,0.38,0.38,0.38,0.38,...
    0.37,0.37,0.37,0.37,0.37,0.37,0.36,0.36];

for i = 1:modelosTotales
    Vp(:,i) = Vs(:,i)*(sqrt(((-2*vd(i))+2)/(1-(2*vd(i)))));
end

figure(5)
ye1 = plot(profundidad,Vs,'- ','LineWidth',1); hold on
ye2 = plot(profundidad,Vp,'-- ','LineWidth',1);
ax = gca;
ax.FontSize = 11;
%axis([0 40 velocidadMinima-50 velocidadMaxima+50])
set(gca,'XMinorTick','on','YMinorTick','on')
ylabel('Velocidad de Onda [m/s]','FontSize', 17)
xlabel('Profundidad [m]','FontSize', 17)
%title({'Modelos de velocidad';'Líneas 1'},'FontSize', 16)
title({'Modelos de velocidad';'Linea 1'},'FontSize', 16)
legend('Vs, tendido 1','Vs, tendido 2','Vp, tendido 1','Vp, tendido 2')
lgd.NumColumns = 2;
view(90,90); 

% Velocidades para calcular módulos más rápido
velocidadrapida=zeros(15,4);
j=1;
for i = 1:length(velocidad);
    if rem(i,2) ~= 0
        velocidadrapida(j,1:4) = velocidad(i,1:4);
        j=j+1;
    end
end





