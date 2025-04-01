point = 141;
ant = 1;
T = point*ant;
packet = 100;

ab = zeros(T*packet,3,30);
coef = zeros(T*packet,3);
power = zeros(T*packet,3);
abx = zeros(T*packet,3,30);
ang = zeros(T*packet,3,30);
I = zeros(T*packet,3,30);
R = zeros(T*packet,3,30);
aoa = zeros(T*packet,3,30);
% ang_offset = zeros(T*packet,3,30);
% b = zeros(T*v,3,1);
% tau = zeros(T*packet,3,1);
% offset = zeros(T*packet,3,30);
  % yy = zeros(T*packet,9);
% yyy = zeros(T*v,1);
% ifft_ab = zeros(T*packet,3,30);
% fft_ab = zeros(T*packet,3,30);
% X = zeros(30,1);
% X(1:30,1) = [-28,-26,-24,-22,-20,-18,-16,-14,-12,-10,-8,-6,-4,-2,-1,1,3,5,7,9,11,13,15,17,19,21,23,25,27,28];
count= zeros(point,3,3);
p_count = 0;

for x = 0:0
    for y = 0:0
        for z = 1:9 % number of AP
            
            if (x==1 && y == 1)
                continue;
            end
%             
            if (z == 5)
%                 continue;
            end
            
%             if z == 1
%                 p = 'G';
%             elseif z == 2
%                 p = 'H';
%             elseif z == 3
%                 p = 'A';
%             elseif z == 4
%                 p = 'B';
%             elseif z == 5
%                 p = 'C';
%             elseif z == 6
%                 p = 'D';
%             elseif z == 7
%                 p = 'E';
%             elseif z == 8
%                 p = 'F';
%             end
            
            if z == 1
                p = 'A';
            elseif z == 2
                p = 'B';
            elseif z == 3
                p = 'C';
            elseif z == 4
                p = 'D';
            elseif z == 5
                p = 'E';
            elseif z == 6
                p = 'F';
            elseif z == 7
                p = 'G';
            elseif z == 8
                p = 'H';
            elseif z == 9
                p = 'I';
            elseif z == 10
                p = 'J';
            elseif z == 11
                p = 'K';
            elseif z == 12
                p = 'L';
            elseif z == 13
                p = 'M';
            elseif z == 14
                p = 'N';
            elseif z == 15
                p = 'O';
            elseif z == 16
                p = 'P';                
            end
            
%             s = sprintf('../csi_%d,%d.mat',x,y);
%             ss = sprintf('../200314/count_200314_%d_%d.txt',x,y);
%             s2 = sprintf('../rssi_%d,%d.mat',x,y);
            
            s = sprintf('./csi_%s.mat',p);
            ss = sprintf('./csi_250227/count_csi_250227_%s.txt',p);
            s2 = sprintf('./rssi_%s.mat',p);
            
            load(s);
            c = load(ss);
            load(s2);
            
            %%mistake for 200322
%             if (z == 5)
%                 c(2) = [];
%                 c(2:point) = c(2:point)-17;
%             end
            
%             temp2 = c(2);
%             c(2) = [];
%             c(2:point) = c(2:point)-temp2;      
            
            
            
            %%mistake for 200311
            %         if (x == 2 && y == 0)
            %             c(2) = [];
            %             c(2:41) = c(2:41)-10;
            %         end
            
            %%%mistake for 200314
%                     if (x == 2 && y == 0)
%                         c = c-3995;
%                         c(1:41) = [];
%                     end
%             
%                     temp26 = c(26);
%                     temp27 = c(27);
%             
%                     ex = c(27) - c(26);
%                     c(27:end) = c(27:end) - ex;
%                     c(26) = [];
            %
            
            %%mistake for 200617
%             temp1 = c(30);
%             temp2=  c(29);
%             c(30) = [];
%             c(30:44) = c(30:44)-(temp1-temp2);

            c = c(1:point,1);
            csi_matrices = csi_matrices(1:c(point,1),1,:,:);
            
            count(:,x+1,y+1) = c;
            csi_matrice = squeeze(csi_matrices(:,1,:,:));
            
            
            %%%mistake for 200322
%             if (z == 5)
%                 csi_matrice(1:17,:,:) = [];
%             end
            
%             csi_matrice(1:temp2,:,:) = [];
            
            %%%mistake for 200311
            %         if (x == 2 && y == 0)
            %             csi_matrice(1:10,:,:) = [];
            %         end
            
            %%%mistake for 200314
%                     if (x == 2 && y == 0)
%                         csi_matrice(1:3995,:,:) = [];
%                         rssi(1:3995,:) = [];
%                     end
%                     csi_matrice(temp26:temp27-1,:,:) = [];
%                     rssi(temp26:temp27-1,:) = [];
            
            %%%mistake for 200617
%                         csi_matrice(temp2+1:temp1,:,:) = [];

            csi = zeros(T*packet,3,30);
            rss = zeros(T*packet,3);
            for i = 1:point
                num = (i-1)*packet+1;
                cnum1 = count(i,x+1,y+1);
                if i < point
                    cnum2 = count(i+1,x+1,y+1)-1;
                else
                    cnum2 = length(csi_matrice);
                end
                csi(num:num+(cnum2-cnum1),:,:) = csi_matrice(cnum1:cnum2,:,:);
                rss(num:num+(cnum2-cnum1),:) = rssi(cnum1:cnum2,:);
                for j = num+(cnum2-cnum1)+1:num+99
                    csi(j,:,:) = csi(num+(cnum2-cnum1),:,:);
                    rss(j,:) = rss(num+(cnum2-cnum1),:);
                end
            end
            
            %         cc = 0;
            %         except = [1,2,3,4,5,6,11,15,20,26,27,28,29,30,34,38];
            %         for i = 1:length(except)
            %             num = (except(i)-1-cc)*200+1 : (except(i)-cc)*200;
            %             csi(num,:,:) = [];
            %             cc = cc+1;
            %         end
            
            ab = abs(csi); % 배열의 복소수 값(진폭과 위상을 포함)을 절댓값으로 변환함. ---> 현재 진폭을 가져옴.
            for i = 1:point*packet
                for j = 1:3
%                     coef(i,j) = sqrt(rss(i,j)/sum(ab(i,j,:).^2));
%                     ab(i,j,:) = ab(i,j,:) .* coef(i,j);
                end
            end

            ang11 = unwrap(angle(squeeze(csi(:,1,:))),pi,2); %csi 배열에서 안테나 1에 대한 위상값을 계산함.
            ang22 = unwrap(angle(squeeze(csi(:,2,:))),pi,2);
            ang33 = unwrap(angle(squeeze(csi(:,3,:))),pi,2);
            
            csi_matrices12 = (csi(:,1,:)./csi(:,2,:)); % 안테나 1번과 안테나 2번의 CSI 비율을 계산함. ---> 상호 위상 분석하는데 사용
            csi_matrices23 = (csi(:,2,:)./csi(:,3,:));
            csi_matrices13 = (csi(:,1,:)./csi(:,3,:)); % 안테나 1과 3의 비율을 사용하지 않는 이유 : 충분히 csi_matrices12와 csi_matrices23으로 csi_matrices13을 만들 수 있기 때문이다.
            
            ang1 = unwrap(angle(squeeze(csi_matrices12)),pi,2); % 안테나 간 csi 비율을 unwrap으로 보정함.
            ang2 = unwrap(angle(squeeze(csi_matrices23)),pi,2);
            R1 = real(csi_matrices12)./abs(csi_matrices12); % 실수부 비율을 계산
            R2 = real(csi_matrices23)./abs(csi_matrices23); 
            R = cat(2,R1,R2); % 실수부를 정규화한 값
            I1 = imag(csi_matrices12)./abs(csi_matrices12); % 허수부 비율을 계산
            I2 = imag(csi_matrices23)./abs(csi_matrices23);
            I = cat(2,I1,I2); % cat()은 배열을 결합한다. % 허수부를 정규화한 값
            RI = cat(3,R,I); 
            
            % R, I, RI 배열에서 NaN 값이 있는 경우 모두 0으로 처리함.
            R(isnan(R))=0;
            I(isnan(I))=0;
            RI(isnan(RI))=0;
            
            if p_count == 0
                RIRI = RI;
                aang = ang1;
              
            else
                RIRI = cat(3, RIRI, RI); 
                aang = cat(2,aang,ang1);
            end
            
            p_count = p_count+1;
            
%             figure;
            for num = 1:5
                if z == 4
                    figure;plot(squeeze(ang1((num-1)*100+1:num*100,:))','b');
                end
%                 if z==6
% 
%                     figure;plot(squeeze(ang22((num-1)*100+1:num*100,:))','b');
%                     xlabel('subcarrier i');
%                     ylabel('phase');
%                     set(gca,'FontSize',13)
%                     figure;plot(squeeze(ang33((num-1)*100+1:num*100,:))','g');
%                     xlabel('subcarrier i');
%                     ylabel('phase');
%                     set(gca,'FontSize',13)
%                     figure;plot(squeeze(ang2((num-1)*100+1:num*100,:))','r');
%                     xlabel('subcarrier i');
%                     ylabel('phase difference');
%                     set(gca,'FontSize',13)
%                     figure;plot(squeeze(R2((num-1)*100+1:num*100,1,:))','b');
%                     xlabel('subcarrier i');
%                     ylabel('in-phase value');
%                     set(gca,'FontSize',13)
%                     figure;plot(squeeze(I2((num-1)*100+1:num*100,1,:))','g');
%                     xlabel('subcarrier i');
%                     ylabel('quadrature value');
%                     set(gca,'FontSize',13)
%                 end
            end
        end
    end
end

% RR = (RR+1)./2;
% II = (II+1)./2;
RIRI = (RIRI+1)./2;

RIRI1 = zeros(1,2,540); % 9(AP의개수)*30(부반송파)*2(안테나위상차) = 540
RIRI2 = zeros(1,2,540);

index = [21,23,25,27,29,31,33,35,37,59,62,72,75,79,82,88,91,102,105,107,115,117,119,121,123,125,127]; %test point점

for i = 1:point %test 파일로 들어감
    if i == 21 || i == 23 || i == 25 || i == 27 || i == 29 || i == 31 || i == 33 || i == 35 || i == 37 || i == 59 || i == 62 || i == 72 || i == 75 || i == 79 || i == 82 || i == 88 || i == 91 || i == 102 || i == 105 || i == 107 || i == 115 || i == 117 || i == 119 || i == 121 || i == 123 || i == 125 || i == 127 
        RIRI2 = cat(1, RIRI2, RIRI((i-1)*100+1:(i-1)*100+100,:,:)); %packet sample 수가 100이므로 500을 100으로 맞춰준다.
    else %train 파일로 들어감
        RIRI1 = cat(1, RIRI1, RIRI((i-1)*100+1:(i-1)*100+100,:,:));
    end
end

RIRI1(1,:,:) = [];
RIRI2(1,:,:) = [];


temp1 = zeros(11400*2*540,1); % 100*141해서 14100개이다.
temp2 = zeros(2700*2*540,1);

for i = 1:11400
    for j = 1:2
        for k = 1:540
            temp1((i-1)*2*540 + (j-1)*540 + k , 1) = RIRI1(i,j,k);
        end
    end
end

for i = 1:2700
    for j = 1:2
        for k = 1:540
            temp2((i-1)*2*540 + (j-1)*540 + k , 1) = RIRI2(i,j,k);
        end
    end
end

% reshape(RIRI(1:2100,:,:),2100*2*240,1);
writematrix(temp1,'result_250227_train.txt','Delimiter','tab');
% reshape(RIRI(2101:2500,:,:),400*2*240,1);
writematrix(temp2,'result_250227_test.txt','Delimiter','tab');



% reshape(RIRI(1:2000,:,:),2000*2*240,1);
% writematrix(ans,'result_240826_train.txt','Delimiter','tab');
% reshape(RIRI(2001:2500,:,:),500*2*240,1);
% writematrix(ans,'result_240826_test.txt','Delimiter','tab');

% v = mean(squeeze(var(RR(1600:2000,1,:),0,1)));
% v = abs(diff(ab,2,1));
% v = mean(mean(ab,3),2);
% v = ab(:,1,:).* ab(:,2,:).* ab(:,3,:);

% v = zeros(120,21);
% v(:,1) = squeeze(var(RIRI(1:500,1,1:120),0,1));
% v(:,2) = squeeze(var(RIRI(1601:2100,1,181:300),0,1));
% v(:,3) = squeeze(var(RIRI(1:500,1,181:300),0,1));
% v(:,4) = squeeze(var(RIRI(1601:2100,1,1:120),0,1)); 
% % v = sort(v);
% 
% % vv = mean(v);
% batch = 1;
% num = floor(21/batch);
% 
% S = zeros(100,num);
% S2 = zeros(100,num);
% count1 = zeros(num,1);
% count2 = zeros(num,1);
% 
% k = 5;
% % v = zeros(120,num);
% % [U,S,V] = svd(A)
% for i = 1:num
%     S(:,i) = svd(squeeze(RIRI((i-1)*batch*100+1:i*batch*100,1,:)));
% %     S2(:,i) = svd(squeeze(RIRI((i-1)*batch*100+1:i*batch*100,1,181:300)));
% %     count1(i,1) = sum(S(:,i)>5);
% %     count2(i,1) = sum(S2(:,i)>5);
% %       [U,S,V] = svd(squeeze(RIRI((i-1)*batch*100+1:i*batch*100,2,1:120)));
% %       [W,H] = nnmf(squeeze(RIRI((i-1)*batch*100+1:i*batch*100,1,:)),k);
% %       v(:,i) = V(:,1);
% %     v(:,i,2) = svd(squeeze(RR(num,1,91:150)));
% end
% figure;plot(v);
% figure;plot(S);

% for i =1:7
%     figure;plot(squeeze((:,:,i))');
% end

% vv = squeeze(v(2,:,:));
% figure;plot(vv(:,16:20));

%       figure;
for num = 4:4
  
%         figure;
    %     color = [0,num*0.1,0];
%         hold on;plot(squeeze(ab((num-1)*100+1:num*100,1,:))','b');
%         hold on;plot(squeeze(ab((num-1)*100+1:num*100,2,:))','r');
%         hold on;plot(squeeze(ab((num-1)*100+1:num*100,3,:))','g');

%           figure;plot(squeeze(RR((num-1)*100+1:num*100,1,:))','b');
%           xlabel('subcarriers for 7 APs view');
%           ylabel('normalized in-phase value');
%           set(gca,'FontSize',13)
%           axis([0 210 0 1])
%           figure;plot(squeeze(II((num-1)*100+1:num*100,1,:))','g');
%           xlabel('subcarriers for 7 APs view');
%           ylabel('normalized quadrature value');
%           set(gca,'FontSize',13)
%           axis([0 210 0 1])

%     figure;plot(squeeze(aang((num-1)*100+1:num*100,:,:))','g');
%     hold on;plot(squeeze(ang2((num-1)*100+1:num*100,:,:))','b');
%         figure;plot(squeeze(ab((num-1)*100+1:num*100,1,:))','Color',color);
%             figure;plot((rss((num-1)*100+1:num*100,1)),'b');
%             hold on;plot((rss((num-1)*100+1:num*100,2)),'r');
%             hold on;plot((rss((num-1)*100+1:num*100,3)),'g');
%         hold on;plot(squeeze(v((num-1)*100+1:num*100,1,:))','b');
%         hold on;plot(squeeze(v((num-1)*100+1:num*100,2,:))','r');
%         hold on;plot(squeeze(v((num-1)*100+1:num*100,3,:))','g');

    %     axis([1 30 0 2])
end


