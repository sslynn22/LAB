% =====================================================================================
% Wi-Fi 칩셋에서 추출한 CSI 로그 파일을 불러와서(read_bf_file) 각 패킷별로 안테나 신호와 RSSI를 처리·저장
% =====================================================================================

% 3중 for문: iiii, jjjj, kkkk 변수를 바꿔가며 여러 파일을 처리하려는 의도.
% 지금은 모두 0:0 범위라 '실제로는 한 번씩만' 실행됨.
for iiii = 0:0 
    for jjjj = 0:0
        for kkkk = 0:0
            
            % 특정 조건( iiii=1 & jjjj=1 )이면 건너뛰도록 함
            if (iiii == 1 && jjjj == 1)
                continue;
            end
            
            % p = 'I'; : 이 스크립트에서 사용할 식별자(문자)
            % 원하는 실험마다 'I', 'A' 등으로 바꾸는 듯
            p = 'I'; % 수정해야함
            
            % 실제 CSI 로그파일 경로 지정, csi 데이터 받음
            % 예) './csi_250227_I'
            s = sprintf('./csi_250227_%s', p);
            
            % read_bf_file() : Wi-Fi 측정 로그를 읽어서
            % csi_trace라는 csi maxtrix 을 만듦
            csi_trace = read_bf_file(s);

            % 아래는 결과물을 저장할 파일 이름
            % 예) 'csi_I.mat'과 'rssi_I.mat'
            s = sprintf('csi_%s.mat', p); 
            fileID = fopen(s,'w');

            s2 = sprintf('rssi_%s.mat', p);
            fileID2 = fopen(s2,'w');

            % 이 로그파일(csi_trace)에 들어있는 패킷 수
            k = length(csi_trace);

            % rssi: 각 패킷마다 안테나별 RSSI를 저장할 배열
            rssi = zeros(k,3);
            
            % ang: (코드 상에선 쓰이지 않는) 위상(phase)을 저장하려 한 흔적
            ang = zeros(3,30,k);

            % ant = 3 : 안테나 개수를 3개로 가정
            ant = 3;
            % csi_matrices : (패킷 수 x 3(TX 안테나) x 3(RX 안테나) x 30(서브캐리어)) 형태
            csi_matrices = zeros(k, ant, 3, 30); 

            % ntemp : (코드 상에서 직접 활용은 안 하지만) 중간 위상 보정 등에 쓰였던 흔적
            ntemp = zeros(k,3,30);

            % ----------------------------
            % 실제로 패킷을 하나씩 처리하는 구간
            % ----------------------------
            for i = 1 : k
                % 안테나 A/B/C의 RSSI 값을 rssi 배열에 저장
                rssi(i,1) = csi_trace{i}.rssi_a;
                rssi(i,2) = csi_trace{i}.rssi_b;
                rssi(i,3) = csi_trace{i}.rssi_c;
                
                % perm : 실제 안테나가 A/B/C 순으로 연결되었는지 확인하는 변수
                perm = csi_trace{i}.perm;
                
                % temp1, temp2 : 임시로 위상/크기 등을 담으려 했던 흔적
                temp1 = zeros(30,3);
                temp2 = zeros(30,3);

                % csi_trace{i}.csi의 크기를 확인
                % i: 1~13994 움직임
                % m = 1, n = 90
                [m,n] = size(csi_trace{i}.csi);

                % csi_matrices(i, 1:m, :, :) = csi_trace{i}.csi;
                % -> i번째 패킷의 CSI를 큰 배열 csi_matrices에 복사
                csi_matrices(i, 1:m, :, :) = csi_trace{i}.csi;

                % 만약 안테나 개수가 2개 미만이라면(=1안테나만 썼다면),
                % 3번째 안테나와 2번째 안테나를 첫 번째 안테나 값으로 복사
                if length(csi_matrices(i,:,1,1)) < 2
                    csi_matrices(i,3,:,:) = csi_matrices(i,1,:,:);
                    csi_matrices(i,2,:,:) = csi_matrices(i,1,:,:);
                % 만약 안테나 개수가 3개 미만(=2안테나)라면,
                % 3번째 안테나를 첫 번째 안테나로 복사
                elseif length(csi_matrices(i,:,1,1)) < 3
                    csi_matrices(i,3,:,:) = csi_matrices(i,1,:,:);
                end

                %----------------------------------------
                % 아래 m=0, m=1, m=2 코드는 특별히 쓰이지 않음.
                % m=0으로 초기화돼 있어서 if문들이 안 쓰이고, 주석처럼 남아있는 상태.
                %----------------------------------------
                m = 0;
                if m == 1
                    % csi_temp1 변수가 정의되어 있지 않아 실제론 동작하지 않음
                    csi_matrices(i,:,:) = csi_temp1;
                elseif m == 2
                    % 아래도 csi_temp가 정의되어 있지 않아 실제론 오류 날 코드
                    csi_temp2 = csi_temp(1,:,:);
                    temp2 = squeeze(csi_temp2);
                    temp2 = unwrap(angle(temp2), pi, 2);

                    % csi_temp1도 정의되지 않아, 실제 구동은 안 됨
                    csi_matrices(i,:,:) = csi_temp2 .* csi_temp1;

                    % '평균 크기'와 '평균 위상'을 구해 다시 복소수 CSI를 만드는 예시
                    csi_abs = (abs(csi_temp2)+abs(csi_temp1))./2;
                    csi_phase = (unwrap(angle(csi_temp2)+angle(csi_temp1), pi, 2))./2;
                    csi_matrices(i,:,:) = csi_abs.*cos(csi_phase) + 1i*csi_abs.*sin(csi_phase);

                    % temp1, temp2의 첫 번째 행끼리 위상차 계산 후
                    % -π/2 ~ π/2 범위에 들도록 반복 보정하는 로직
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
                end
                %----------------------------------------
                % for문 끝
            end
            % 패킷 루프 종료
            %--------------------------------------------
            
            % 이제 완성된 csi_matrices와 rssi를
            % 각각 'csi_*.mat', 'rssi_*.mat' 파일에 저장
            save(s, 'csi_matrices');
            fclose(fileID);

            save(s2, 'rssi');
            fclose(fileID2);

        end
    end
end
