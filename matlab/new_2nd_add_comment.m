% =========================================================================
% AP 에서 수집한 CSI 데이터를 불러와 전처리하고, 그 결과를 학습용과 테스트용 텍스트 파일로 저장
% =========================================================================

% 측정 포인트, 안테나 수, 패킷 수 등 실험 설정 값
point = 141;        % 총 측정 포인트 수 (예: 서로 다른 위치 또는 시간에 대한 측정)
ant = 1;            % 사용 안테나 수 (여기서는 1개로 설정)
T = point * ant;    % 전체 샘플 수의 기본 단위 (여기서는 point와 동일)
packet = 100;       % 각 포인트당 사용할 패킷 수

% 결과를 저장할 배열 초기화
ab    = zeros(T*packet, 3, 30);  % CSI의 진폭 정보를 저장 (3채널, 30 부반송파)
coef  = zeros(T*packet, 3);       % 보정 계수를 저장할 배열 (미사용 자리)
power = zeros(T*packet, 3);       % 전력 값 저장용 배열 (미사용 자리)
abx   = zeros(T*packet, 3, 30);   % 추가 진폭 데이터 저장용 배열 (미사용 자리)
ang   = zeros(T*packet, 3, 30);   % 위상(phase) 정보를 저장할 배열
I     = zeros(T*packet, 3, 30);   % 정규화된 허수부 저장 배열
R     = zeros(T*packet, 3, 30);   % 정규화된 실수부 저장 배열
aoa   = zeros(T*packet, 3, 30);   % 도착각(AoA) 관련 데이터를 저장 (미사용 자리)

% 각 포인트별 패킷 카운트 정보를 저장할 배열 (point x 3 x 3)
count = zeros(point, 3, 3);
p_count = 0;  % 처리한 AP(Access Point)의 개수를 카운트

% for 루프: x, y는 나중에 여러 위치 또는 조건에 따른 데이터를 처리하기 위한 변수 
% 현재는 0:0 범위로 단 한 번만 실행됨
for x = 0:0
    for y = 0:0
        % AP의 개수를 나타내는 for문 (z: 1부터 9까지, 즉 9개의 AP 처리)
        for z = 1:9 % number of AP
            % 특정 조건에서 건너뛰기 (여기서는 x와 y가 1인 경우)
            if (x == 1 && y == 1)
                continue;
            end

            % (z가 5인 경우에 대한 조건을 넣을 수 있으나 현재는 아무 작업도 없음)
            if (z == 5)
            end

            % AP 번호(z)에 따라 문자 식별자(p) 설정 
            % 예: 1 → 'A', 2 → 'B', …, 9 → 'I'
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
          
            % 파일 경로 설정: AP별로 저장된 CSI, 패킷 카운트, RSSI 데이터 파일 불러오기
            s  = sprintf('./csi_%s.mat', p);                         % 예: csi_A.mat
            ss = sprintf('./count_csi_250227_%s.txt', p);  % 각 포인트별 패킷 카운트 정보
            s2 = sprintf('./rssi_%s.mat', p);                         % 예: rssi_A.mat
            
            % 파일에서 데이터 로드
            load(s);         % CSI 데이터 (보통 csi_matrices 변수 포함)
            c = load(ss);    % 패킷 카운트 정보 (각 포인트 시작 인덱스)
            load(s2);        % RSSI 데이터 로드
            
            % 패킷 카운트 정보를 포인트 수만큼 자름 (첫 번째 열만 사용)
            c = c(1:point, 1);
            % CSI 데이터 배열을 마지막 포인트의 인덱스까지 잘라냄
            csi_matrices = csi_matrices(1:c(point, 1), 1, :, :);
            
            % count 배열에 현재 (x, y) 조건의 패킷 카운트 정보를 저장
            count(:, x+1, y+1) = c;
            % 4차원 배열 csi_matrices에서 불필요한 차원을 제거하여 3차원 배열로 변환
            csi_matrice = squeeze(csi_matrices(:, 1, :, :));

            % 각 포인트별 CSI 및 RSSI 데이터를 재구성하기 위해 새로운 배열 초기화
            csi = zeros(T*packet, 3, 30);  % 재구성된 CSI 데이터를 저장할 배열
            rss = zeros(T*packet, 3);       % 재구성된 RSSI 데이터를 저장할 배열
            
            % 각 측정 포인트에 대해 반복 (총 point개)
            for i = 1:point
                % 현재 포인트에 해당하는 시작 인덱스 계산 (packet 단위)
                num = (i - 1) * packet + 1;
                % 현재 포인트의 CSI 데이터 시작 인덱스
                cnum1 = count(i, x+1, y+1);
                % 다음 포인트의 시작 인덱스 - 1, 또는 마지막 포인트이면 전체 길이 사용
                if i < point
                    cnum2 = count(i+1, x+1, y+1) - 1;
                else
                    cnum2 = length(csi_matrice);
                end
                % 현재 포인트의 실제 CSI 데이터를 재배열하여 csi 배열에 저장
                csi(num : num + (cnum2 - cnum1), :, :) = csi_matrice(cnum1 : cnum2, :, :);
                % RSSI 데이터도 동일하게 재배열하여 저장
                rss(num : num + (cnum2 - cnum1), :) = rssi(cnum1 : cnum2, :);
                % 만약 현재 포인트의 패킷 수가 100개보다 적으면, 마지막 패킷 값을 반복하여 채움
                for j = num + (cnum2 - cnum1) + 1 : num + 99
                    csi(j, :, :) = csi(num + (cnum2 - cnum1), :, :);
                    rss(j, :) = rss(num + (cnum2 - cnum1), :);
                end
            end
            
            % 복소수 CSI 값에서 진폭(absolute value)을 계산 (위상 정보는 제거됨)
            ab = abs(csi); 
            % 아래 반복문은 보정 계수 등 추가 작업을 위한 자리 (현재 내용 없음)
            for i = 1:point*packet
                for j = 1:3
                    % 추가 계산 가능 (예: coef 계산)
                end
            end

            % 각 안테나별로 CSI 데이터의 위상(phase)을 계산하고 unwrap()으로 보정
            ang11 = unwrap(angle(squeeze(csi(:, 1, :))), pi, 2); % 안테나 1 위상
            ang22 = unwrap(angle(squeeze(csi(:, 2, :))), pi, 2); % 안테나 2 위상
            ang33 = unwrap(angle(squeeze(csi(:, 3, :))), pi, 2); % 안테나 3 위상
            
            % 안테나 간 CSI 비율을 계산하여 상호 위상 분석에 사용
            csi_matrices12 = (csi(:, 1, :) ./ csi(:, 2, :)); % 안테나 1 / 안테나 2
            csi_matrices23 = (csi(:, 2, :) ./ csi(:, 3, :)); % 안테나 2 / 안테나 3
            csi_matrices13 = (csi(:, 1, :) ./ csi(:, 3, :)); % 안테나 1 / 안테나 3 (보통은 사용하지 않음)
            
            % 위상 차이를 계산 및 보정
            ang1 = unwrap(angle(squeeze(csi_matrices12)), pi, 2); 
            ang2 = unwrap(angle(squeeze(csi_matrices23)), pi, 2);
            
            % 안테나 간 CSI 비율의 실수부와 허수부를 정규화 (각 요소를 해당 절댓값으로 나눔)
            R1 = real(csi_matrices12) ./ abs(csi_matrices12);
            R2 = real(csi_matrices23) ./ abs(csi_matrices23);
            R  = cat(2, R1, R2);  % 두 결과를 좌우로 결합
            I1 = imag(csi_matrices12) ./ abs(csi_matrices12);
            I2 = imag(csi_matrices23) ./ abs(csi_matrices23);
            I  = cat(2, I1, I2);  % 두 결과를 좌우로 결합
            RI = cat(3, R, I);    % 실수부와 허수부를 3차원 배열로 결합
            
            % NaN 값이 발생한 경우 모두 0으로 대체
            R(isnan(R)) = 0;
            I(isnan(I)) = 0;
            RI(isnan(RI)) = 0;
            
            % AP별 결과(RI, 위상 데이터)를 누적하여 저장
            if p_count == 0
                RIRI = RI;
                aang = ang1;
            else
                RIRI = cat(3, RIRI, RI);   % 기존 결과에 새로운 AP 데이터 추가 (3번째 차원 결합)
                aang = cat(2, aang, ang1);  % 위상 데이터도 2번째 차원으로 결합
            end
            
            % 처리한 AP 개수 증가
            p_count = p_count + 1;
            
            % 조건에 따라 일부 데이터(여기서는 AP 번호 z가 4일 때)의 위상을 그래프로 출력
            for num = 1:5
                if z == 4
                    figure;
                    plot(squeeze(ang1((num-1)*100+1 : num*100, :))', 'b');
                end
            end
        end
    end
end

% 누적된 RI 값을 [0,1] 범위로 정규화
RIRI = (RIRI + 1) ./ 2;

% 학습 데이터와 테스트 데이터를 저장할 배열 초기화
RIRI1 = zeros(1, 2, 540);  % (9 AP * 30 부반송파 * 2 위상 차이 = 540)
RIRI2 = zeros(1, 2, 540);

% 테스트 포인트로 사용할 측정 포인트 인덱스 (여기서는 예시로 지정)
index = [21,23,25,27,29,31,33,35,37,59,62,72,75,79,82,88,91,102,105,107,115,117,119,121,123,125,127];

% 각 측정 포인트별로 데이터를 학습용과 테스트용으로 분리
for i = 1:point
    if i == 21 || i == 23 || i == 25 || i == 27 || i == 29 || i == 31 || ...
       i == 33 || i == 35 || i == 37 || i == 59 || i == 62 || i == 72 || ...
       i == 75 || i == 79 || i == 82 || i == 88 || i == 91 || i == 102 || ...
       i == 105 || i == 107 || i == 115 || i == 117 || i == 119 || ...
       i == 121 || i == 123 || i == 125 || i == 127
        % 각 포인트당 100 패킷이므로 해당 범위의 데이터를 테스트용 배열에 누적
        RIRI2 = cat(1, RIRI2, RIRI((i-1)*100+1 : (i-1)*100+100, :, :));
    else
        % 테스트 포인트가 아니면 학습용 배열에 누적
        RIRI1 = cat(1, RIRI1, RIRI((i-1)*100+1 : (i-1)*100+100, :, :));
    end
end

% 초기값으로 사용된 첫 번째 행 제거
RIRI1(1,:,:) = [];
RIRI2(1,:,:) = [];

% 학습 및 테스트 데이터를 1차원 벡터로 재구성하기 위한 임시 배열 생성
temp1 = zeros(11400*2*540, 1);  % 학습 데이터: 총 11400 패킷 * 2 * 540 요소
temp2 = zeros(2700*2*540, 1);   % 테스트 데이터: 총 2700 패킷 * 2 * 540 요소

% 3중 for문을 통해 학습 데이터 배열 RIRI1을 1차원 벡터로 변환
for i = 1:11400
    for j = 1:2
        for k = 1:540
            temp1((i-1)*2*540 + (j-1)*540 + k, 1) = RIRI1(i, j, k);
        end
    end
end

% 테스트 데이터 배열 RIRI2를 1차원 벡터로 변환
for i = 1:2700
    for j = 1:2
        for k = 1:540
            temp2((i-1)*2*540 + (j-1)*540 + k, 1) = RIRI2(i, j, k);
        end
    end
end

% 최종적으로 학습 데이터와 테스트 데이터를 텍스트 파일로 저장 (탭 구분자 사용)
writematrix(temp1, 'result_250227_train.txt', 'Delimiter', 'tab');
writematrix(temp2, 'result_250227_test.txt', 'Delimiter', 'tab');

for num = 4:4
end