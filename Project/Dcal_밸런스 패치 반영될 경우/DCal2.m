%% initialize
clear
clc
%=== 직업 리스트(12직업)===
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

%섀도어
skill_step = 650;
skill_sh = 350;
hits_step = 4;
hits_sh = 2; %부스 + 시브즈 + 시브즈 이기에 시브즈 1회 시전 타수 = 2 로 설정
mob_step = 6;
mob_sh = 6;

%바이퍼 드래곤스트라이크/샤크웨이브 데이터
skill_ds = 400;
skill_sw = 900;
hits_ds = 3; %타수
hits_sw = 2;
mob_ds = 8; %공격 몹수
mob_sw = 6;

%% input
%=== 입력값(능력치) ===
lv = 1000; %정복자 레벨
ap_premium = 1000; %스텍작 횟수(풀)
No_MAX = 10*10^6; %맥뎀 제한 수치
No_MAX0 = 10*10^6; %맥뎀 제한 수치(법격)

buff_mul = 1; %데미지 기본 증폭 계수

%버프 적용 질문지
question1 = input('메이플 용사 ON/OFF\n');
question2 = input('샤프아이즈(파티버프) ON/OFF\n');
question3 = input('윈드부스터(파티버프) ON/OFF\n');
question4 = input('영웅의 메아리[1]/스페셜 영웅의 메아리[2] ON/OFF\n');

%주스탯/보조스탯
ap = [
436	,	349
436	,	349
436	,	349
436	,	349
436	,	349
880	,	389
880	,	389
880	,	389
436	,	349
436	,	349
436	,	349
436	,	349
];

%공격력/마력
phy_mag_ap=[
1082
1082
1074
980
1069
1279
1279
1279
1069
1074
1031
1027
];

%직업 무기 선택(입력) 데이터 
job_weapon_factor = [
    {'히어로','두손검'} 
    {'다크나이트','폴암'}
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

%=== 정보 수집용 ===
%1타 스킬 데미지  
one_hit_skill_dmg = job(:,1);

%% 데이터 모음
%=== 무기 기본 데이터 ===
%한손검
weapon_factor(1,1) =  {'한손검'}; %장비 종류
weapon_factor(1,2) = {4}; %Min Factor
weapon_factor(1,3) = {4}; %Max Factor
weapon_factor(1,5) = {2}; %공속 수치(자체부스터 고려)
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
weapon_factor(6,5) = {4};
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
    {'다크나이트','폴암 쓰레셔',0,102,0,92,0,0,0,0}
    {'팔라딘','생츄어리',5,5,5,5,5,5,5,5}%{'팔라딘','어차',100,90,83,80,74,69,67,0}
    {'나이트로드','어벤져',95,0,0,0,0,0,0,0}
    {'섀도어','부메랑 스탭/시브즈',31,0,0,0,0,0,0,0}
    {'아크메이지(썬,콜)','체인 라이트닝',87,0,0,0,0,0,0,0}%{'아크메이지(썬,콜)','블리자드',19,0,0,0,0,0,0,0} 
    {'아크메이지(불,독)','메테오',19,0,0,0,0,0,0,0} %{'아크메이지(불,독)','패럴라이징',83,0,0,0,0,0,0,0}  
    {'비숍','제네시스',22,0,0,0,0,0,0,0}
    {'보우마스터','폭풍의시',440,440,440,440,440,440,440,440}%{'보우마스터','애로우 레인',100,90,83,80,74,0,0,0}
    {'신궁','피어싱',94,0,80,0,0,0,0,0} 
    {'바이퍼','드래곤 스트라이크/샤크웨이브',42,0,0,0,0,0,0,0}
    {'캡틴','배틀쉽:토르페도',83,77,0,0,0,0,0,0}
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
    ]; 

%공격력/마력 추가 스킬
buff2 = [ 
    {'히어로','분노',40}
    {'히어로','인레이지',50}
    {'다크나이트','드래곤 블러드',40}
    {'보우마스터','보우엑스퍼트',10}
    {'보우마스터','집중',30}
    {'신궁','크로스보우엑스퍼트',10}
    {'바이퍼','에너지차지',30}
    {'아크메이지(썬,콜)','메디테이션',20}
    {'아크메이지(불,독)','메디테이션',20}
    ];

%=== 공격 스킬 ===
%패치
skill = [
    {'히어로','브랜디쉬',450,2,4} 
    {'다크나이트','폴암 쓰레셔',410,1,6} 
    {'팔라딘','어차',500,1,8} 
    {'나이트로드','어벤져',200,1,6}
    {'섀도어','부메랑 스탭/시브즈',650,1,0}      
    {'아크메이지(썬,콜)','체인 라이트닝',240,4,1}%{'아크메이지(썬,콜)','블리자드',320,2,15}
    {'아크메이지(불,독)','메테오',320,2,15}
    {'비숍','제네시스',420,2,15}
    {'보우마스터','폭풍의시',300,1,1}%{'보우마스터','애로우 레인',200,1,6}
    {'신궁','피어싱',200,1,6} 
    {'바이퍼','드래곤 스트라이크/샤크웨이브',3150,1,0}
    {'캡틴','배틀쉽:토르페도',680,2,6}
    ];

skill(:,8) = skill(:,5);
one_hit_skill_dmg(:,2) = skill(:,2); %사용 스킬 입력
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
    disp('윈드부스터 적용!');
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
    p_ap0 = floor( p_ap0 * cell2mat(buff0(1,3)) );
    disp('메이플 용사 적용!');
end
    
%영웅의 메아리(4%)/스페셜 영웅의 메아리(15%)
if question4 == 1
    special_buff = 1.04;
    disp('영웅의 메아리 적용!');
elseif question4 == 2
    special_buff = 1.15;
    disp('스페셜 영웅의 메아리 적용!');
else
    special_buff = 1;
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
    phy_ap = phy_mag_ap(ii,1);
    for jj=1:a
        if strcmp( cell2mat(buff2(jj,1)), str)
            phy_ap = phy_ap + cell2mat(buff2(jj,3));
        end
    end
    
    %영웅의 메아리 적용식(물리공격력)
    phy_ap = floor(special_buff*phy_ap); 
    
    %스탯 계산
    p_ap = p_ap0 + ap(ii,1) + ap_premium;
    s_ap = s_ap0 + ap(ii,2);
    
    %스탯 공격력 계산    
    phy(:,1) = job(:,1); 
    [a,b] = size(phy); clear b;
    if strcmp('스피어 버스터',cell2mat(skill(ii,2)))
        job_weapon_factor(ii,3) = {5};
    end
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
    
    skill_min_dmg1 = floor(buff_mul*min*skill_fac0/100);
    skill_min_dmg2 = floor(buff_mul*min*skill_fac1/100);
    skill_max_dmg1 = floor(buff_mul*max*skill_fac0/100);
    skill_max_dmg2 = floor(buff_mul*max*skill_fac1/100);
    
    % 맥뎀 제한
    % - 신궁 맥뎀 제한(모탈 터질 경우)
    %{
    if strcmp(str,'신궁')
         No_MAX =  No_MAX*2;
    end
    %}
    
    if skill_min_dmg1 >= No_MAX
       skill_min_dmg1 = No_MAX-1; 
    end
    if skill_min_dmg2 >= No_MAX
       skill_min_dmg2 = No_MAX-1; 
    end
    if skill_max_dmg1 >= No_MAX
       skill_max_dmg1 = No_MAX-1; 
    end
    if skill_max_dmg2 >= No_MAX
       skill_max_dmg2 = No_MAX-1;    
    end
    
    %{
    if strcmp(str,'신궁')
         No_MAX =  No_MAX/2; % 다시 원래 값으로 되돌리기
    end
    %}
    
    %데이터 수집
    one_hit_skill_dmg(ii,3) = {skill_min_dmg1}; %노크리
    one_hit_skill_dmg(ii,4) = {skill_max_dmg1}; %노크리
    one_hit_skill_dmg(ii,5) = {skill_min_dmg2}; %크리
    one_hit_skill_dmg(ii,6) = {skill_max_dmg2}; %크리 
    
    %공격 몹 수
    mob = cell2mat(skill(ii,8));
    
    DPM(ii,2) = { floor( (skill_min_dmg1*skill_hit_1+ skill_min_dmg2*skill_hit_2)*mob ) };
    DPM(ii,3) = { floor( (skill_max_dmg1*skill_hit_1+ skill_max_dmg2*skill_hit_2)*mob ) };
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %별도 공식 스킬 재계산
    % - 나이트로드 (어벤져) 
    if strcmp('나이트로드', str)
        %본체(1타)
        skill0_min_dmg1 = floor(min*skill_fac0/100);
        skill0_min_dmg2 = floor(min*skill_fac1/100);
        skill0_max_dmg1 = floor(max*skill_fac0/100);
        skill0_max_dmg2 = floor(max*skill_fac1/100);
        
        if skill0_min_dmg1 >= No_MAX
        	skill0_min_dmg1 = No_MAX-1;
        end
        if skill0_min_dmg2 >= No_MAX
            skill0_min_dmg2 = No_MAX-1;
        end
        if skill0_max_dmg1 >= No_MAX
        	skill0_max_dmg1 = No_MAX-1; 
        end
        if skill0_max_dmg2 >= No_MAX
            skill0_max_dmg2 = No_MAX-1;    
        end
        
        %그림자(1타)     
        skill1_min_dmg1 = floor( (buff_mul-1)*skill0_min_dmg1 ); 
        skill1_min_dmg2 = floor( (buff_mul-1)*skill0_min_dmg2 );
        skill1_max_dmg1 = floor( (buff_mul-1)*skill0_max_dmg1 );
        skill1_max_dmg2 = floor( (buff_mul-1)*skill0_max_dmg2 );
        
        %데이터 수집
        one_hit_skill_dmg(ii,3) = {skill0_min_dmg1}; %노크리
        one_hit_skill_dmg(ii,4) = {skill0_max_dmg1}; %노크리
        one_hit_skill_dmg(ii,5) = {skill0_min_dmg2}; %크리
        one_hit_skill_dmg(ii,6) = {skill0_max_dmg2}; %크리 
    
        DPM(ii,2) = {  floor( ((skill0_min_dmg1+skill1_min_dmg1)*skill_hit_1 + (skill0_min_dmg2+skill1_min_dmg2)*skill_hit_2 ))*mob };
        DPM(ii,3) = {  floor( ((skill0_max_dmg1+skill1_max_dmg1)*skill_hit_1 + (skill0_max_dmg2+skill1_max_dmg2)*skill_hit_2 ))*mob };
        clear skill0_min_dmg1 skill0_min_dmg2 skill0_max_dmg1 skill0_max_dmg2 skill1_min_dmg1 skill1_min_dmg2 skill1_max_dmg1 skill1_max_dmg2
    end
    
    % - 신궁 (피어싱)
    if strcmp('피어싱',cell2mat(skill(ii,2)))
        mobs = cell2mat(skill(ii,8));
        
        DPM_min_sum = floor( (skill_min_dmg1*skill_hit_1) + (skill_min_dmg2*skill_hit_2) );
        DPM_max_sum = floor( (skill_max_dmg1*skill_hit_1) + (skill_max_dmg2*skill_hit_2) );
        
        for jj=2:mobs
            DPM_min_sum = DPM_min_sum + floor( (skill_min_dmg1*1.2^(jj-1)*skill_hit_1) + (skill_min_dmg2*1.2^(jj-1)*skill_hit_2) );
            DPM_max_sum = DPM_max_sum + floor( (skill_max_dmg1*1.2^(jj-1)*skill_hit_1) + (skill_max_dmg2*1.2^(jj-1)*skill_hit_2) );
        end
        
        DPM(ii,2) = {DPM_min_sum};
        DPM(ii,3) = {DPM_max_sum};
        clear DPM_min_sum DPM_max_sum mobs
    end
    
    % - 팔라딘 (생츄어리)
    %
    if strcmp('생츄어리', cell2mat(skill(ii,2)))
        crr = (add_dmg+100)/100;
        npmm = cell2mat(skill(ii,7));
        sca1 = floor( buff_mul*( skill_cri_opp*crr)*(p_ap*400+1200*phy_ap)*55/25);
        sca2 = floor( buff_mul*((1-skill_cri_opp))*(p_ap*400+1200*phy_ap)*55/25);
        if sca1 >= No_MAX0
            sca1 = No_MAX0-1;
        end
        if sca2 >= No_MAX0
            sca2 = No_MAX0-1; 
        end
    
        DPM(ii,2) = { (sca1 + sca2)*mob*npmm};
        DPM(ii,3) = { (sca1 + sca2)*mob*npmm };
        clear crr npmm sca1 sca2;
    end
    %}
    
    % - 섀도어 (부스/시브즈)
    if strcmp('섀도어', str)
       %부스
       skill_fac0 = skill_step;                         
       skill_fac1 = skill_step + 100 + add_dmg;
       skill1_min_dmg1 = floor(buff_mul*min*skill_fac0/100);
       skill1_min_dmg2 = floor(buff_mul*min*skill_fac1/100);
       skill1_max_dmg1 = floor(buff_mul*max*skill_fac0/100);
       skill1_max_dmg2 = floor(buff_mul*max*skill_fac1/100);
       
       %시브즈
       skill_fac0 = skill_sh;
       skill_fac1 = skill_sh + 100 + add_dmg;                                   
       skill2_min_dmg1 = floor(buff_mul*min*skill_fac0/100);
       skill2_min_dmg2 = floor(buff_mul*min*skill_fac1/100);
       skill2_max_dmg1 = floor(buff_mul*max*skill_fac0/100);
       skill2_max_dmg2 = floor(buff_mul*max*skill_fac1/100);
       
       % 맥뎀 제한
        if skill1_min_dmg1 >= No_MAX
           skill1_min_dmg1 = No_MAX-1; 
        end
        if skill1_min_dmg2 >= No_MAX
           skill1_min_dmg2 = No_MAX-1; 
        end
        if skill1_max_dmg1 >= No_MAX
           skill1_max_dmg1 = No_MAX-1; 
        end
        if skill1_max_dmg2 >= No_MAX
           skill1_max_dmg2 = No_MAX-1;    
        end
        
        if skill2_min_dmg1 >= No_MAX
           skill2_min_dmg1 = No_MAX-1; 
        end
        if skill2_min_dmg2 >= No_MAX
           skill2_min_dmg2 = No_MAX-1; 
        end
        if skill2_max_dmg1 >= No_MAX
           skill2_max_dmg1 = No_MAX-1; 
        end
        if skill2_max_dmg2 >= No_MAX
           skill2_max_dmg2 = No_MAX-1;    
        end
        
        %데이터 수집
        one_hit_skill_dmg(ii,3) = {skill1_min_dmg1}; %노크리
        one_hit_skill_dmg(ii,4) = {skill1_max_dmg1}; %노크리
        one_hit_skill_dmg(ii,5) = {skill1_min_dmg2}; %크리
        one_hit_skill_dmg(ii,6) = {skill1_max_dmg2}; %크리
        
        one_hit_skill_dmg(ii,7) = {skill2_min_dmg1}; %노크리
        one_hit_skill_dmg(ii,8) = {skill2_max_dmg1}; %노크리
        one_hit_skill_dmg(ii,9) = {skill2_min_dmg2}; %크리
        one_hit_skill_dmg(ii,10) = {skill2_max_dmg2}; %크리
        
        DPM(ii,2) = {  floor( (skill1_min_dmg1*hits_step*mob_step+skill2_min_dmg1*hits_sh*mob_sh)*skill_hit_1 + (skill1_min_dmg2*hits_step*mob_step+skill2_min_dmg2*hits_sh*mob_sh)*skill_hit_2 ) };
        DPM(ii,3) = {  floor( (skill1_max_dmg1*hits_step*mob_step+skill2_max_dmg1*hits_sh*mob_sh)*skill_hit_1 + (skill1_max_dmg2*hits_step*mob_step+skill2_max_dmg2*hits_sh*mob_sh)*skill_hit_2 ) };
        clear  skill_step skill_sh npm_step npm_sh mob_step mob_sh;
        clear  skill1_min_dmg1 skill1_min_dmg2 skill1_max_dmg1 skill1_max_dmg2;
        clear  skill2_min_dmg1 skill2_min_dmg2 skill2_max_dmg1 skill2_max_dmg2;
        
    end
    % - 바이퍼
    if strcmp('바이퍼', str)
        %드래곤스트라이크 1타(450퍼 3번 8마리)
        skill_fac0 = skill_ds;
        skill_fac1 = skill_ds + 100 + add_dmg;
        skill1_min_dmg1 = floor(buff_mul*min*skill_fac0/100);
        skill1_min_dmg2 = floor(buff_mul*min*skill_fac1/100);
        skill1_max_dmg1 = floor(buff_mul*max*skill_fac0/100);
        skill1_max_dmg2 = floor(buff_mul*max*skill_fac1/100);
        
        %샤크웨이브 1타(900퍼 2타 6마리)
        skill_fac0 = skill_sw;
        skill_fac1 = skill_sw + 100 + add_dmg;
        skill2_min_dmg1 = floor(buff_mul*min*skill_fac0/100);
        skill2_min_dmg2 = floor(buff_mul*min*skill_fac1/100);
        skill2_max_dmg1 = floor(buff_mul*max*skill_fac0/100);
        skill2_max_dmg2 = floor(buff_mul*max*skill_fac1/100);

        % 맥뎀 제한
        if skill1_min_dmg1 >= No_MAX
           skill1_min_dmg1 = No_MAX-1; 
        end
        if skill1_min_dmg2 >= No_MAX
           skill1_min_dmg2 = No_MAX-1; 
        end
        if skill1_max_dmg1 >= No_MAX
           skill1_max_dmg1 = No_MAX-1; 
        end
        if skill1_max_dmg2 >= No_MAX
           skill1_max_dmg2 = No_MAX-1;    
        end
        
        if skill2_min_dmg1 >= No_MAX
           skill2_min_dmg1 = No_MAX-1; 
        end
        if skill2_min_dmg2 >= No_MAX
           skill2_min_dmg2 = No_MAX-1; 
        end
        if skill2_max_dmg1 >= No_MAX
           skill2_max_dmg1 = No_MAX-1; 
        end
        if skill2_max_dmg2 >= No_MAX
           skill2_max_dmg2 = No_MAX-1;    
        end
        
        %데이터 수집
        one_hit_skill_dmg(ii,3) = {skill1_min_dmg1}; %노크리
        one_hit_skill_dmg(ii,4) = {skill1_max_dmg1}; %노크리
        one_hit_skill_dmg(ii,5) = {skill1_min_dmg2}; %크리
        one_hit_skill_dmg(ii,6) = {skill1_max_dmg2}; %크리
        
        one_hit_skill_dmg(ii,7) = {skill2_min_dmg1}; %노크리
        one_hit_skill_dmg(ii,8) = {skill2_max_dmg1}; %노크리
        one_hit_skill_dmg(ii,9) = {skill2_min_dmg2}; %크리
        one_hit_skill_dmg(ii,10) = {skill2_max_dmg2}; %크리
        
        %샤크웨이브 반감 고려
        sum_skill2_min_dmg1 = 0; sum_skill2_max_dmg1=0;sum_skill2_min_dmg2=0;sum_skill2_max_dmg2=0;
        for jjj=1:mob_sw
            sum_skill2_min_dmg1 = sum_skill2_min_dmg1+skill2_min_dmg1/(2^(jjj-1));
            sum_skill2_max_dmg1 = sum_skill2_max_dmg1+skill2_max_dmg1/(2^(jjj-1));
            sum_skill2_min_dmg2 = sum_skill2_min_dmg2+skill2_min_dmg2/(2^(jjj-1));
            sum_skill2_max_dmg2 = sum_skill2_max_dmg2+skill2_max_dmg2/(2^(jjj-1));
        end
        
        DPM(ii,2) = {  floor( (skill1_min_dmg1*hits_ds*mob_ds + sum_skill2_min_dmg1*hits_sw)*skill_hit_1 + (skill1_min_dmg2*hits_ds*mob_ds + sum_skill2_min_dmg2*hits_sw)*skill_hit_2 ) };
        DPM(ii,3) = {  floor( (skill1_max_dmg1*hits_ds*mob_ds + sum_skill2_max_dmg1*hits_sw)*skill_hit_1 + (skill1_max_dmg2*hits_ds*mob_ds + sum_skill2_max_dmg2*hits_sw)*skill_hit_2 ) };
        clear  skill_ds skill_sw npm_ds npm_sw mob_ds mob_sw;
        clear  skill1_min_dmg1 skill1_min_dmg2 skill1_max_dmg1 skill1_max_dmg2;
        clear  skill2_min_dmg1 skill2_min_dmg2 skill2_max_dmg1 skill2_max_dmg2;
        clear sum_skill2_min_dmg1 sum_skill2_max_dmg1 sum_skill2_min_dmg2 sum_skill2_max_dmg2
    end
end

%% 버프 및 스탯 계산(마법 공격력)
[a,b] = size(job); clear b;
for ii=6:8
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
    mag_ap = phy_mag_ap(ii,1);
    for jj=1:a
        if strcmp( cell2mat(buff2(jj,1)), str)
            mag_ap = mag_ap + cell2mat(buff2(jj,3)); 
        end
    end
        
    %스탯 계산
    p_ap = floor(p_ap0) + ap(ii,1) +  ap_premium;
    
    %스킬 데미지 계산
    skill_npm = cell2mat(skill(ii,7));
    skill_hit0 = cell2mat(skill(ii,4));
    skill_cri_opp = cell2mat(skill(ii,5)); %크리 확률
    skill_fac1 = (add_dmg+100)/100; %크리티컬 뎀지 고려 스킬 데미지 증폭 계수 (마법사 특수)
    
    skill_hit_1 = skill_hit0*(1-skill_cri_opp)*skill_npm;
    skill_hit_2 = skill_hit0*skill_cri_opp*skill_npm;
    
    %스킬 1타 데미지
    %노크리
    min0 = floor( buff_mul*((0.0033665*(special_buff*(p_ap+mag_ap))^2 + 3.3*(special_buff*(p_ap+mag_ap))*0.9*0.6 + 0.5*p_ap)*cell2mat(skill(ii,3))/100) ); %1타 데미지
    max0 = floor( buff_mul*((0.0033665*(special_buff*(p_ap+mag_ap))^2 + 3.3*(special_buff*(p_ap+mag_ap)) + 0.5*p_ap)*cell2mat(skill(ii,3))/100) ); %1타 데미지
    %크리
    min1 = floor( skill_fac1*buff_mul*((0.0033665*(special_buff*(p_ap+mag_ap))^2 + 3.3*(special_buff*(p_ap+mag_ap))*0.9*0.6 + 0.5*p_ap)*cell2mat(skill(ii,3))/100) ); %1타 데미지
    max1 = floor( skill_fac1*buff_mul*((0.0033665*(special_buff*(p_ap+mag_ap))^2 + 3.3*(special_buff*(p_ap+mag_ap)) + 0.5*p_ap)*cell2mat(skill(ii,3))/100) ); %1타 데미지
    
    %맥뎀 제한
    if min0 >= No_MAX0
        min0 = No_MAX0-1;
    end
    if max0 >= No_MAX0
        max0 = No_MAX0-1;
    end 
    if min1 >= No_MAX0
        min1 = No_MAX0-1;
    end
    if max1 >= No_MAX0
        max1 = No_MAX0-1;
    end 
    
    %공격 몹 수
    mob = cell2mat(skill(ii,8));
    
    %데이터 수집
    one_hit_skill_dmg(ii,3) = {min0}; %노크리
    one_hit_skill_dmg(ii,4) = {max0}; %노크리
    one_hit_skill_dmg(ii,5) = {min1}; %크리
    one_hit_skill_dmg(ii,6) = {max1}; %크리 
    
    DPM(ii,2) = {(min0*skill_hit_1 + min1*skill_hit_2)*mob};
    DPM(ii,3) = {(max0*skill_hit_1 + max1*skill_hit_2)*mob};
end
 
%% 순위 나열 (평균 사냥기 DPM 기준)
[a,b] = size(DPM); clear b;
for ii=1:a
   DPM(ii,4) = {floor( ( cell2mat(DPM(ii,2)) + cell2mat(DPM(ii,3)) )/2 )};
end
DPM_rank0 = sort(cell2mat(DPM(:,4)),'Descend');
for ii=1:a
    DPM_rank(ii,6) = {DPM_rank0(ii)};
end
for ii=1:a
   k = find(cell2mat(DPM(:,4)) == cell2mat(DPM_rank(ii,6)));
   
   %순위 매기기
   [c,d] = size(k); clear d;
   if c > 1 && isempty(cell2mat(DPM_rank(ii,1))) %동순위 있을 경우
       for iii=1:c
           kk = k(iii);
           DPM_rank(ii,1) = DPM(kk,1);

           DPM_rank(ii,2) = phy(kk,2);
           DPM_rank(ii,3) = phy(kk,3);

           DPM_rank(ii,4) = one_hit_skill_dmg(kk,3);
           DPM_rank(ii,5) = one_hit_skill_dmg(kk,4); 
           ii = ii +1;
       end
       clear k kk iii;
   elseif c == 1
       DPM_rank(ii,1) = DPM(k,1);
   
       DPM_rank(ii,2) = phy(k,2);
       DPM_rank(ii,3) = phy(k,3);

       DPM_rank(ii,4) = one_hit_skill_dmg(k,3);
       DPM_rank(ii,5) = one_hit_skill_dmg(k,4);  
   end
  
end

for ii=1:a
    DPM_rank(ii,6) = { cell2mat(DPM_rank(ii,6))/10^8 };
end


