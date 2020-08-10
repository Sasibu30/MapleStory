%% initialize
clear
clc

%=== 직업 리스트===
job = [
    {'히어로'}
    {'다크나이트'}
    {'팔라딘'}
    {'나이트로드'}
    {'섀도어'}
    {'아크메이지(썬,콜)'} 
    {'아크메이지(불,독)'}
    {'비숍'} 
    {'보우마스터'}
    {'신궁'}
    {'바이퍼'}
    {'캡틴'}
    ];

%% input
%=== 입력값(능력치) ===
lv = 300; %정복자 레벨
p_ap1 = 700; %추가 주스탯
s_ap1 = 240; %추가 보조스탯
phy_ap0 = 400; %총 공격력
mag_ap0 = 400; %총 마력

%버프 적용 질문지
question1 = input('메이플 용사 ON/OFF\n');
question2 = input('샤프아이즈(파티버프) ON/OFF\n');
question3 = input('윈드부스터(파티버프) ON/OFF\n');

buff_mul = 1; %데미지 기본 증폭 계수

%직업 무기 선택(입력) 데이터 
job_weapon_factor = [
    {'히어로','두손검'} 
    {'다크나이트','창'}
    {'팔라딘','한손검'}
    {'나이트로드','아대'}
    {'섀도어','단검'}
    {'아크메이지(썬,콜)','스태프'} 
    {'아크메이지(불,독)','스태프'}
    {'비숍','스태프'}
    {'보우마스터','활'}; 
    {'신궁','석궁'}
    {'바이퍼','너클'}
    {'캡틴','총'} 
    ];


%% 데이터 모음
%=== 무기 기본 데이터 ===
%한손검
weapon_factor(1,1) =  {'한손검'}; %장비 종류
weapon_factor(1,2) = {4}; %Min Factor
weapon_factor(1,3) = {4}; %Max Factor
weapon_factor(1,5) = {3}; %공속 수치(자체부스터 고려)
%두손검
weapon_factor(2,1) = {'두손검'};
weapon_factor(2,2) = {4.6};
weapon_factor(2,3) = {4.6};
weapon_factor(2,5) = {3}; 
%한손도끼
weapon_factor(3,1) = {'한손도끼'};
weapon_factor(3,2) = {3.2};
weapon_factor(3,3) = {4.4};
weapon_factor(3,5) = {4};
%두손도끼
weapon_factor(4,1) = {'두손도끼'};
weapon_factor(4,2) = {3.4};
weapon_factor(4,3) = {4.8}; 
weapon_factor(4,5) = {5};
%창
weapon_factor(5,1) = {'창'};
weapon_factor(5,2) = {3};
weapon_factor(5,3) = {5};
weapon_factor(5,5) = {3};
%폴암
weapon_factor(6,1) = {'폴암'};
weapon_factor(6,2) = {3};
weapon_factor(6,3) = {5};
weapon_factor(6,5) = {3};
%아대
weapon_factor(7,1) = {'아대'};
weapon_factor(7,2) = {3.6};
weapon_factor(7,3) = {3.6};
weapon_factor(7,5) = {1};
%단검
weapon_factor(8,1) = {'단검'};
weapon_factor(8,2) = {3.6};
weapon_factor(8,3) = {3.6};
weapon_factor(8,5) = {1};
%활
weapon_factor(9,1) = {'활'};
weapon_factor(9,2) = {3.4};
weapon_factor(9,3) = {3.4};
weapon_factor(9,5) = {3};
%석궁
weapon_factor(10,1) = {'석궁'};
weapon_factor(10,2) = {3.6};
weapon_factor(10,3) = {3.6};
weapon_factor(10,5) = {3};
%너클
weapon_factor(11,1) = {'너클'};
weapon_factor(11,2) = {4.8};
weapon_factor(11,3) = {4.8};
weapon_factor(11,5) = {1};
%총
weapon_factor(12,1) = {'총'};
weapon_factor(12,2) = {3.6};
weapon_factor(12,3) = {3.6};
weapon_factor(12,5) = {1};

%==무기 마스터리 수치== 
weapon_factor(:,4) = {0.6};
weapon_factor(5:6,4) = {0.8};
weapon_factor(9:10,4) = {0.9};

%=== 직업 스킬 NPM 데이터 ===
skill_NPM = [
    {'히어로','브랜디쉬',95,87,80,74,72,67,63,0}
    {'다크나이트','버스터',74,69,66,61,59,53,50,48}
    {'팔라딘','블래스트/생츄',95,87,80,74,72,67,63,0}
    {'나이트로드','트리플스로우',100,0,0,0,0,0,0,0}
    {'섀도어','새비지',83,0,0,0,0,0,0,0}
    {'아크메이지(썬,콜)','체인 라이트닝',87,0,0,0,0,0,0,0}
    {'아크메이지(불,독)','패럴라이징',83,0,0,0,0,0,0,0}
    {'비숍','엔젤레이',74,0,0,0,0,0,0,0}
    {'보우마스터','폭풍의시',500,500,500,500,500,500,500,500}
    {'신궁','스트레이트',94,86,82,76,70,0,0,0}
    {'바이퍼','드래곤 스트라이크/샤크웨이브',40,0,0,0,0,0,0,0}
    {'캡틴','배틀쉽:캐논',100,96,0,80,0,0,0,0}
];

%=== 버프스킬 ===
%증폭 스킬
buff0 = [ {'공용', '메이플 용사', 1.15} ];
buff1 = [ 
    {'아크메이지(썬,콜)', '엘리먼트 엠플리케이션', 1.5}
    {'아크메이지(불,독)', '엘리먼트 엠플리케이션', 1.5}
    {'히어로', '어드밴스드 콤보', 1.9}
    {'다크나이트', '버서크', 2.1}
    {'나이트로드', '쉐도우파트너', 1.6}
    {'신궁', '모탈블로우', 2}
    {'캡틴', '어드밴스드 호밍', 1.2}
    ]; 

%공격력/마력 추가 스킬
buff2 = [ 
    {'히어로','분노',40}
    {'히어로','인레이지',50}
    {'다크나이트','비홀더',3}
    {'다크나이트','드래곤 블러드',40}
    {'보우마스터','보우엑스퍼트',10}
    {'보우마스터','집중',30}
    {'신궁','크로스보우엑스퍼트',10}
    {'바이퍼','에너지차지',30}
    {'아크메이지(썬,콜)','메디테이션',20}
    {'아크메이지(불,독)','메디테이션',20}
    ];

%=== 공격 스킬 ===
skill = [
    {'히어로','브랜디쉬',450,2}
    {'다크나이트','버스터',250,4}
    {'팔라딘','블래스트/생츄',700,1}
    {'나이트로드','트리플스로우',200,4}
    {'섀도어','새비지',235,6}
    {'아크메이지(썬,콜)','체인 라이트닝',550,2}
    {'아크메이지(불,독)','패럴라이징',240,4}
    {'비숍','엔젤레이',240,2}
    {'보우마스터','폭풍의시',230,1}
    {'신궁','스트레이트',200,6}
    {'바이퍼','드래곤 스트라이크/샤크웨이브',3150,1}
    {'캡틴','배틀쉽:캐논',480,5}
    ];

%% 입력값 기반 능력치 계산 
%=== 기본 크리티컬 확률/추가 크리티컬 데미지 ===
if question2 > 0
    %샤프아이즈 적용
    opp = 0.3; %크리티컬 확률
    add_dmg = 50; %추가 크리티컬 데미지
    disp('샤프 아이즈 적용!');
else
    %샤프아이즈 미적용
    opp = 0; %크리티컬 확률
    add_dmg = 0; %추가 크리티컬 데미지 
end

%궁수의 경우 자체 버프로 샤프아이즈 사용하기에 고려
opp0 = 0.3; %크리티컬 확률
add_dmg0 = 50; %추가 크리티컬 데미지

job(:,2) = {0+opp};
job(4,2) = {0.5+opp};
job(9:10,2) = {0.4+opp0}; %궁수는 샤프아이즈 사용하였다고 고려

job(:,3) = {100+add_dmg};
job(4,3) = {200+add_dmg};
job(9:10,3) = {200+add_dmg0}; %궁수는 샤프아이즈 사용하였다고 고려

%무기 공속 수치 조정
if question3 > 0
    [a,b] = size(weapon_factor); clear b;
    for ii=1:a 
       weapon_factor(ii,5) = { cell2mat(weapon_factor(ii,5)) - 2 };
       if cell2mat(weapon_factor(ii,5)) <= 0
           weapon_factor(ii,5) = { 1 };
       end
    end
end

%직업별 사용 무기 데이터 정리(무기 상수,무기 마스터리,무기 공속 계수)
[a,b] = size(job_weapon_factor); clear b;
for ii=1:a
    str = cell2mat(job_weapon_factor(ii,2));
    for jj=1:a
        if strcmp( cell2mat(weapon_factor(jj,1)), str)
            job_weapon_factor(ii,3) = (weapon_factor(jj,2));
            job_weapon_factor(ii,4) = (weapon_factor(jj,3));
            job_weapon_factor(ii,5) = (weapon_factor(jj,4));
            job_weapon_factor(ii,6) = (weapon_factor(jj,5));
        end
    end
end

%크리티컬 수치 고려한 스킬 데미지 계산 (마법사는 증폭으로 적용)
[a,b] = size(job); clear b;
for ii=1:a
    if strcmp(cell2mat(skill(ii,1)),'비숍') || strcmp(cell2mat(skill(ii,1)),'아크메이지(썬,콜)') || strcmp(cell2mat(skill(ii,1)),'아크메이지(불,독)')
        skill(ii,5) = { cell2mat(job(ii,2)) }; %크리티컬 확률
    else
        skill(ii,5) = { cell2mat(job(ii,2)) }; %크리티컬 확률
        skill(ii,6) = { cell2mat(skill(ii,3)) + cell2mat(job(ii,3)) }; %크리티컬 추가 데미지
    end
end

%직업별 스킬 NPM 정리
[a,b] = size(job_weapon_factor); clear b;
for ii=1:a
    jj = cell2mat(job_weapon_factor(ii,6))+2;
    skill(ii,7) = {cell2mat(skill_NPM(ii,jj))};
    
    %마법사 따로 고려
    if strcmp(cell2mat(skill(ii,1)),'비숍') || strcmp(cell2mat(skill(ii,1)),'아크메이지(썬,콜)') || strcmp(cell2mat(skill(ii,1)),'아크메이지(불,독)')
       skill(ii,7) = {cell2mat(skill_NPM(ii,3))};
    end
end

%job_weapon_factor & skill 데이터 정리 완료

%% 능력치 계산
%순수 AP
p_ap0 = 18 + 5*249; 
s_ap0 = 4;

if lv < 500 && lv >= 0
    quo = floor(lv/100);
    rem = lv - quo*100;
    add = 0;
    
    for ii=0:quo-1
        p_ap0 = p_ap0 + (5+ii)*100; %ini~final (0~99, 100~199) 
        add = ii+1;
    end
    
    p_ap0 = p_ap0 + (5+add)*(rem+1);
    
elseif lv >= 500
    p_ap0 = 4763;
    lv0 =lv-500;
    quo = floor(lv0/100);
    rem = lv0 - quo*100;
    add = 0;
    
    for ii=0:quo-1
        p_ap0 = p_ap0 + (11+ii)*100; %ini~final (0~99, 100~199) 
        add = ii+1;
    end
    
    p_ap0 = p_ap0 + (11+add)*(rem+1);  
end

%메이플 용사 적용 유무
if question1 > 0
    p_ap0 = p_ap0 * cell2mat(buff0(1,3));
    disp('메이플 용사 적용!');
end

%% 버프 및 스탯 계산(물리 공격력)
DPM(:,1) = job(:,1);
[a,b] = size(job); clear b;

for ii=1:a
    str = cell2mat(DPM(ii,1));
    
    %버프(데미지 증폭)
    [a,b] = size(buff1); clear b; buff_mul=1;
    for jj=1:a
        if strcmp( cell2mat(buff1(jj,1)), str)
            buff_mul = cell2mat(buff1(jj,3)); 
        end
    end
    
    %버프(추가 공격력/마력)
    [a,b] = size(buff2); clear b;
    phy_ap = 0;
    for jj=1:a
        if strcmp( cell2mat(buff2(jj,1)), str)
            phy_ap = phy_ap0 + cell2mat(buff2(jj,3));
        else
            phy_ap = phy_ap0;
        end
    end
    
    %스탯 계산  
    p_ap = floor(p_ap0) + p_ap1;
    s_ap = floor(s_ap0) + s_ap1;

    %스탯 공격력 계산    
    phy(:,1) = job(:,1); 
    [a,b] = size(phy); clear b;
    phy(ii,2) = { floor( phy_ap/100*( p_ap*cell2mat(job_weapon_factor(ii,3))*0.9*cell2mat(job_weapon_factor(ii,5)) + s_ap ) ) };
    phy(ii,3) = { floor( phy_ap/100*( p_ap*cell2mat(job_weapon_factor(ii,4)) + s_ap ) ) };
    
    %스킬 데미지 계산
    min = cell2mat(phy(ii,2));
    max = cell2mat(phy(ii,3));
    skill_npm = cell2mat(skill(ii,7));
    skill_fac0 = cell2mat(skill(ii,3));
    skill_hit0 = cell2mat(skill(ii,4)); %스킬 1회 타수
    skill_cri_opp = cell2mat(skill(ii,5)); %크리 확률
    skill_fac1 = cell2mat(skill(ii,6)); %추가 크리뎀지 고려 스킬 계수   
    
    skill_hit_1 = skill_hit0*(1-skill_cri_opp)*skill_npm;
    skill_hit_2 = skill_hit0*skill_cri_opp*skill_npm;
     
    DPM(ii,2) = { floor( buff_mul*(min*skill_fac0/100*skill_hit_1+ min*skill_fac1/100*skill_hit_2) ) };
    DPM(ii,3) = { floor( buff_mul*(max*skill_fac0/100*skill_hit_1+ max*skill_fac1/100*skill_hit_2) ) };
    
    %별도 공식 스킬 재계산
    % - 나이트로드 (트리플 스로우)
    if strcmp('나이트로드', str)
        DPM(ii,2) = { floor( buff_mul*phy_ap/100*p_ap*2.5*(skill_fac0/100*skill_hit_1+ skill_fac1/100*skill_hit_2) ) };
        DPM(ii,3) = { floor( buff_mul*phy_ap/100*p_ap*5*(skill_fac0/100*skill_hit_1+ skill_fac1/100*skill_hit_2) ) };
    end
    
end

%% 버프 및 스탯 계산(마법 공격력)
[a,b] = size(job); clear b;
for ii=1:a
    str = cell2mat(DPM(ii,1));
    
    %버프(데미지 증폭)
    [a,b] = size(buff1); clear b; buff_mul=1;
    for jj=1:a
        if strcmp( cell2mat(buff1(jj,1)), str)
            buff_mul = cell2mat(buff1(jj,3)); 
        end
    end
    
    %버프(추가 마력)
    [a,b] = size(buff2); clear b;
    mag_ap = mag_ap0;
    for jj=1:a
        if strcmp( cell2mat(buff2(jj,1)), str)
            mag_ap = mag_ap + cell2mat(buff2(jj,3)); 
        end
    end
    
    %스탯 계산
    p_ap = floor(p_ap0) + p_ap1;
    
    %스킬 데미지 계산
    skill_npm = cell2mat(skill(ii,7));
    skill_hit0 = cell2mat(skill(ii,4));
    skill_cri_opp = cell2mat(skill(ii,5)); %크리 확률
    skill_fac1 = 1.5; %크리티컬 뎀지 고려 스킬 데미지 증폭 계수 (마법사 특수)
    
    skill_hit_1 = skill_hit0*(1-skill_cri_opp)*skill_npm;
    skill_hit_2 = skill_hit0*skill_cri_opp*skill_npm;
    
    min = buff_mul*((0.0033665*(p_ap+mag_ap)^2 + 3.3*(p_ap+mag_ap)*0.9*0.6 + 0.5*p_ap)*cell2mat(skill(ii,3))/100); %1타 데미지
    max = buff_mul*((0.0033665*(p_ap+mag_ap)^2 + 3.3*(p_ap+mag_ap) + 0.5*p_ap)*cell2mat(skill(ii,3))/100); %1타 데미지
    
    min = min*skill_hit_1 + min*skill_hit_2*skill_fac1;
    max = max*skill_hit_1 + max*skill_hit_2*skill_fac1;
    
    DPM(ii,2) = {min};
    DPM(ii,3) = {max};
end
 
%% 순위 나열 (평균화)
[a,b] = size(DPM); clear b;
for ii=1:a
   DPM(ii,4) = {( cell2mat(DPM(ii,2)) + cell2mat(DPM(ii,3)) )/2};
end
DPM_rank0 = sort(cell2mat(DPM(:,4)),'Descend');
for ii=1:a
    DPM_rank(ii,2) = {DPM_rank0(ii)};
end
for ii=1:a
   k = find(cell2mat(DPM(:,4)) == cell2mat(DPM_rank(ii,2)));
   DPM_rank(ii,1) = DPM(k,1);
end



