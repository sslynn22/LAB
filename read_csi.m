% csi_trace = read_bf_file("./sample_data/log.all_csi.6.7.6");
% csi_trace = read_bf_file("./0310/csi_0310_3cm_5m_70_");
% csi_trace = read_bf_file("./0208/csi_0208_6cm_2.5m_45");
% csi_trace = read_bf_file("./0322/csi_0322_3cm_5m_0_");

% csi_trace = read_bf_file("./0711/csi_0711_1.5cm_5m_0");
% csi_trace = read_bf_file("./1011/csi_1011_6cm_5m_0");
% csi_trace = read_bf_file("./0109/csi_0109_3cm_5m_0,1");

% csi_trace = read_bf_file("./1214/csi_1214_6cm_5m_0_g");
% csi_trace = read_bf_file("./1122/csi_1122_6cm_5m_0_2");
% csi_trace = read_bf_file("./1025/csi_1025_6cm_5m_0");
% csi_trace = read_bf_file("./0525/csi_0525_3cm_5m_0_");
% csi_trace = read_bf_file("./0329/csi_0329_3cm_5m_-45_");
% csi_trace = read_bf_file("./0322/lgtm-monitor.dat--1m-neg-10-degrees--laptop-1--test-1");

% for iiii = -1:1
%     for jjjj = 0:2
%         s = sprintf('./0124/csi_0124_3cm_%d,%d_2_',jjjj,iiii);
%         csi_trace = read_bf_file(s);
%         s = sprintf('csi%d,%d_2.mat',jjjj,iiii);
%         fileID = fopen(s,'a+')
for iiii = 0:0
    for jjjj = 0:0
        for kkkk = 0:0
            %             for ii = 1:16
            %             s = sprintf('./191112/csi_191112_%d,%d_A',kkkk,jjjj);
            %                 s = sprintf('./191123/csi_191123_180_%d,%d_D',kkkk,jjjj);
            %                 s = sprintf('./191117/csi_191117_%d,%d_D',kkkk,jjjj);
            %                 s = sprintf('./191123/csi_191123_180_%d_A',jjjj);
            if (iiii == 1 && jjjj ==1)
                continue;
            end
%             s = sprintf('./200314/csi_200314_%d,%d',iiii,jjDDjj);
            p = 'A';
            s = sprintf('./csi_241028/csi_241028_%s',p);
            %%% 3월 11일 2,0 데이터 앞에 10개 지우기!!!!
%             s = sprintf('./200722_mobile/csi2');
            csi_trace = read_bf_file(s);
            %         s = sprintf('csi30_%d_c.mat',iiii);
            %                 s = sprintf('csi_%d,%d_D.mat',kkkk,jjjj);
            %                 s = sprintf('csi_%d_.mat',ii);
            %                 s = sprintf('csi_%d_A.mat',jjjj);
%             s = sprintf('csi_%d,%d.mat',iiii,jjjj);
            s = sprintf('csi_%s.mat',p);
            fileID = fopen(s,'w');
            
%             s2 = sprintf('rssi_%d,%d.mat',iiii,jjjj);
            s2 = sprintf('rssi_%s.mat',p);
            fileID2 = fopen(s2,'w');
            %
            %             s = sprintf('./190819/csi_%d_',kkkk);
            %             %         s = sprintf('./190422/csi_190422_4,6cm_5m_0_%d',iiii);
            %             csi_trace = read_bf_file(s);
            %             %         s = sprintf('csi30_%d_c.mat',iiii);
            %             s = sprintf('csi_%d.mat',kkkk);
            %             fileID = fopen(s,'w');

            % 0413 데이터 rx B 수정
%                         k = 5181;
            
            k = length(csi_trace);
%             k = 0;
%             for i = 1:length(csi_trace)
%                 if isempty(csi_trace{i}) == 0
%                     k = k+1;
%                 end
%             end

            % csi_matrices2 = zeros(length(csi_trace),3,30);
            rssi = zeros(k,3);
            ang = zeros(3,30,k);
            % perm = zeros(length(csi_trace),3);
            
            
            ant = 3;
            csi_matrices = zeros(k,ant,3,30);
            ntemp = zeros(k,3,30);
            
            
            % for i = 1 : 1
            % for i = 1 : length(csi_trace)
            for i = 1 : k
                %     i = i+1000;
                %     csi_temp = csi_trace{i};
                rssi(i,1) = csi_trace{i}.rssi_a;
                rssi(i,2) = csi_trace{i}.rssi_b;
                rssi(i,3) = csi_trace{i}.rssi_c;
                perm = csi_trace{i}.perm;
                %     csi_temp = get_scaled_csi(csi_temp);
                %     temp = csi_temp;
                %     csi_temp = csi_temp(1,:,:);
                
                %     csi_temp = squeeze(csi_temp);
                %     csi_matrices(i,:,:) = csi_temp;
                %
                %     csi_temp2 = [csi_temp(1,:)  csi_temp(2,:) csi_temp(3,:)];
                %     temp2 = unwrap(angle(csi_temp2),pi,2);
                
                temp1 = zeros(30,3);
                temp2 = zeros(30,3);
                
                
                [m,n] = size(csi_trace{i}.csi);
                
                csi_matrices(i,1:m,:,:) = csi_trace{i}.csi;
                
                %                     temp1 = csi_matrices(i,1:m,perm(1),:);
                %                     temp2 = csi_matrices(i,1:m,perm(2),:);
                %                     temp3 = csi_matrices(i,1:m,perm(3),:);
                %                     csi_matrices(i,1:m,1,:) = temp1;
                %                     csi_matrices(i,1:m,2,:) = temp2;
                %                     csi_matrices(i,1:m,3,:) = temp3;
                
                
                %     csi_temp = get_scaled_csi(csi_temp);
                if length(csi_matrices(i,:,1,1)) < 2
                    csi_matrices(i,3,:,:) = csi_matrices(i,1,:,:);
                    csi_matrices(i,2,:,:) = csi_matrices(i,1,:,:);
                elseif length(csi_matrices(i,:,1,1)) < 3
                    csi_matrices(i,3,:,:) = csi_matrices(i,1,:,:);
                    
                end
                %     csi_temp1 = csi_temp.csi(1,:,:);
                %                     temp1 = squeeze(csi_temp1);
                %                     temp1 = unwrap(angle(temp1),pi,2);
                
                %     temp1(1,:) = temp1(1,:) - 0.16*2*pi;
                %     temp1(2,:) = temp1(2,:) - 0.08*2*pi;
                %     temp1(3,:) = temp1(3,:) + 0.05*2*pi;
                
                %                     ntemp(i,:,:) = temp1;
                
                %                     temp = squeeze(ntemp(i,:,:));
                %             ntemp(i,:,:) = sanitize(temp')';
                
                
                m = 0;
                if m == 1
                    csi_matrices(i,:,:) = csi_temp1;
                elseif m == 2
                    %         i
                    csi_temp2 = csi_temp(1,:,:);
                    temp2 = squeeze(csi_temp2);
                    temp2 = unwrap(angle(temp2),pi,2);
                    %                 temp3 = temp1 + temp2;
                    %
                    csi_matrices(i,:,:) = csi_temp2.*csi_temp1;
                    csi_abs = (abs(csi_temp2)+abs(csi_temp1))./2;
                    csi_phase = (unwrap(angle(csi_temp2)+angle(csi_temp1),pi,2))./2;
                    csi_matrices(i,:,:) = csi_abs.*cos(csi_phase) + 1i*csi_abs.*sin(csi_phase);
                    
                    %                 temp4 = squeeze(csi_temp1)+squeeze(csi_temp2);
                    %                 temp4 = unwrap(angle(temp4),pi,2);
                    
                    temp11 = temp1(1,:)'-temp1(2,:)';
                    temp22 = temp2(1,:)'-temp2(2,:)';
                    
                    while temp11(1,1) < 0
                        temp11(:,1) = temp11(:,1) + pi/2;
                    end
                    while temp11(1,1) > pi/2
                        temp11(:,1) = temp11(:,1) - pi/2;
                    end
                    while temp22(1,1) < 0
                        temp22(:,1) = temp22(:,1) + pi/2;
                    end
                    while temp22(1,1) > pi/2
                        temp22(:,1) = temp22(:,1) - pi/2;
                    end
                    
                    
                    %                 figure;plot(temp11);hold on;plot(temp22);
                    %                 figure;plot(temp11+temp22);
                    
                end
                %             hold off;
                %     csi_temp2 = [csi_temp1(1,:)  csi_temp1(2,:) csi_temp1(3,:)];
                %     csi_matrices(i,:) = csi_temp2;
                %     temp5 = unwrap(angle(csi_temp5),pi,2);
                
                
                
            end
            %
            %                 % figure;scatter(1:k, ntemp(:,1,15)/2/pi-ntemp(:,2,15)/2/pi);
            %
            %                 pd = zeros(k,2);
            %
            %                 % pd(:,1) = (ntemp(:,1,20)-ntemp(:,2,20));
            %                 % pd(:,2) = (ntemp(:,2,20)-ntemp(:,3,20));
            %
            %                 %         for i = 1:k
            %                 %             pd(i,1) = mean(mean(ntemp(i,1,:)))-mean(mean(ntemp(i,2,:)));
            %                 %             pd(i,2) = mean(mean(ntemp(i,2,:)))-mean(mean(ntemp(i,3,:)));
            %                 %         end
            %                 %
            %                 %         for j = 1 : 2
            %                 %             for i = 1:k
            %                 %                 if pd(i,j) > pi/2
            %                 %                     while pd(i,j) > pi/2
            %                 %                         pd(i,j) = pd(i,j) - pi/2;
            %                 %                     end
            %                 %                 elseif pd(i,j) < -pi/2
            %                 %                     while pd(i,j) < -pi/2
            %                 %                         pd(i,j) = pd(i,j) + pi/2;
            %                 %                     end
            %                 %                 end
            %                 %             end
            %                 %         end
            %                 %         pd = pd/2/pi;
            %
            %                 % figure(1);scatter(1:k, pd(:,2));
            %                 % title('CSI phase difference for subcarrier 20');
            %                 % xlabel('Packet number');
            %                 % ylabel('Phase');
            %
            %                 ct1 = real(csi_matrices(:,1,16));
            %                 st1 = imag(csi_matrices(:,1,16));
            %                 ct2 = real(csi_matrices(:,2,16));
            %                 st2 = imag(csi_matrices(:,2,16));
            %                 %         figure;scatter(ct1.*ct2 - st1.*st2 , st1.*ct2 + ct1.*st2);
            %
            %                 %         figure;scatter(real(csi_matrices(:,2,2)),imag(csi_matrices(:,2,2)));
            %                 % figure;scatter(real(csi_trace{:}.csi(:,1,20)),imag(csi_trace{:}.csi(:,1,20)));
            %                 % title('CSI phase for subcarrier 20');
            %                 % xlabel('Real number');
            %                 % ylabel('Imaginary number');
            %
            %                 uw = zeros (30,3);
            %                 newuw = zeros (30,3,k);
            %                 diff = zeros(30,2,k);
            %
            %                 for i = 1:k
            %                     temp1 = unwrap(angle(transpose(squeeze(csi_matrices(i,1,:)))),pi,2);
            %                     temp2 = unwrap(angle(transpose(squeeze(csi_matrices(i,2,:)))),pi,2);
            %                     temp3 = unwrap(angle(transpose(squeeze(csi_matrices(i,3,:)))),pi,2);
            %                     temp = [temp1 ; temp2 ; temp3];
            %
            %                     uw(:,1) = temp(1,:);
            %                     uw(:,2) = temp(2,:);
            %                     uw(:,3) = temp(3,:);
            %
            %                     for j = 1 : 2
            %
            %                         if mean(uw(:,j+1)) < mean(uw(:,j)) - pi/4
            %                             while 1
            %                                 if mean(uw(:,j+1)) > mean(uw(:,j)) - pi/4 && mean(uw(:,j+1)) < mean(uw(:,j)) + pi/4
            %                                     break;
            %                                 end
            %                                 uw(:,j+1) = uw(:,j+1) + pi/2;
            %                                 %             plus(j,1) = plus(j,1) + 1;
            %
            %                             end
            %                         elseif mean(uw(:,j+1)) > mean(uw(:,j)) + pi/4
            %                             while 1
            %                                 if mean(uw(:,j+1)) > mean(uw(:,j)) - pi/4 && mean(uw(:,j+1)) < mean(uw(:,j)) + pi/4
            %                                     break;
            %                                 end
            %                                 uw(:,j+1) = uw(:,j+1) - pi/2;
            %                                 %             minus(j,1) = minus(j,1) + 1;
            %                             end
            %                         end
            %
            %                     end
            %
            %                     newuw(:,:,i) = uw;
            %                     diff(:,1,i) = newuw(:,1,i) - newuw(:,2,i);
            %                     diff(:,2,i) = newuw(:,2,i) - newuw(:,3,i);
            %
            %                     for j = 1:2
            %                         while mean(diff(:,j,i)) > pi/2
            %                             diff(:,j,i) = diff(:,j,i) - pi/2;
            %                         end
            %
            %                         while mean(diff(:,j,i)) < 0
            %                             diff(:,j,i) = diff(:,j,i) + pi/2;
            %                         end
            %                     end
            %
            %
            %                 end
            %
            %
            %                 % csi_matrices = csi_matrices(200:300,:,:);
            %
            save(s,'csi_matrices');
            fclose(fileID);
            
            save(s2,'rssi');
            fclose(fileID2);
            
            % system('cd C:\Users\kms\Dropbox\연구\localization\matlab\egaebel');
            % system('main');
            %     end
            % end
            
            %             end
        end
    end
end




