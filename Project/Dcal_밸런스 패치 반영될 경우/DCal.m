%% initialize
clear
clc
%=== ���� ����Ʈ(12����)===
job = [
    {'�����'}
    {'��ũ����Ʈ'}
    {'�ȶ��'}
    {'����Ʈ�ε�'}
    {'������'}
    {'��ũ������(��,��)'} 
    {'��ũ������(��,��)'}
    {'���'} 
    {'���츶����'}
    {'�ű�'}
    {'������'}
    {'ĸƾ'}
    ];

%������ �巡�ｺƮ����ũ/��ũ���̺� ������
skill_ds = 400;
skill_sw = 900;
npm_ds=3;
npm_sw=2;

%���츶���� ��Ż��ο� ������
bow1_opp = 0.1;
bow1_mul = 3;
%% input
%=== �Է°�(�ɷ�ġ) ===
lv = 1000; %������ ����
ap_premium = 1400; %������ Ƚ��(Ǯ)
No_MAX = 10*10^6; %�Ƶ� ���� ��ġ
buff_mul = 1; %������ �⺻ ���� ���

%���� ���� ������
question1 = input('������ ��� ON/OFF\n');
question2 = input('����������(��Ƽ����) ON/OFF\n');
question3 = input('����ν���(��Ƽ����) ON/OFF\n');
question4 = input('������ �޾Ƹ�[1]/����� ������ �޾Ƹ�[2] ON/OFF\n');

%�ֽ���/��������
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

%���ݷ�/����
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

%���� ���� ����(�Է�) ������ 
job_weapon_factor = [
    {'�����','�μհ�'} 
    {'��ũ����Ʈ','â'}
    {'�ȶ��','�Ѽհ�'}
    {'����Ʈ�ε�','�ƴ�'}
    {'������','�ܰ�'}
    {'��ũ������(��,��)','������'} 
    {'��ũ������(��,��)','������'}
    {'���','������'}
    {'���츶����','Ȱ'}; 
    {'�ű�','����'}
    {'������','��Ŭ'}
    {'ĸƾ','��'} 
    ];

%=== ���� ������ ===
%1Ÿ ��ų ������  
one_hit_skill_dmg = job(:,1);

%% ������ ����
%=== ���� �⺻ ������ ===
%�Ѽհ�
weapon_factor(1,1) =  {'�Ѽհ�'}; %��� ����
weapon_factor(1,2) = {4}; %Min Factor
weapon_factor(1,3) = {4}; %Max Factor
weapon_factor(1,5) = {2}; %���� ��ġ(��ü�ν��� ���)
%�μհ�
weapon_factor(2,1) = {'�μհ�'};
weapon_factor(2,2) = {4.6};
weapon_factor(2,3) = {4.6};
weapon_factor(2,5) = {3}; 
%�Ѽյ���
weapon_factor(3,1) = {'�Ѽյ���'};
weapon_factor(3,2) = {3.2};
weapon_factor(3,3) = {4.4};
weapon_factor(3,5) = {4};
%�μյ���
weapon_factor(4,1) = {'�μյ���'};
weapon_factor(4,2) = {3.4};
weapon_factor(4,3) = {4.8}; 
weapon_factor(4,5) = {5};
%â
weapon_factor(5,1) = {'â'};
weapon_factor(5,2) = {3};
weapon_factor(5,3) = {5};
weapon_factor(5,5) = {3};
%����
weapon_factor(6,1) = {'����'};
weapon_factor(6,2) = {3};
weapon_factor(6,3) = {5};
weapon_factor(6,5) = {4};
%�ƴ�
weapon_factor(7,1) = {'�ƴ�'};
weapon_factor(7,2) = {3.6};
weapon_factor(7,3) = {3.6};
weapon_factor(7,5) = {1};
%�ܰ�
weapon_factor(8,1) = {'�ܰ�'};
weapon_factor(8,2) = {3.6};
weapon_factor(8,3) = {3.6};
weapon_factor(8,5) = {1};
%Ȱ
weapon_factor(9,1) = {'Ȱ'};
weapon_factor(9,2) = {3.4};
weapon_factor(9,3) = {3.4};
weapon_factor(9,5) = {3};
%����
weapon_factor(10,1) = {'����'};
weapon_factor(10,2) = {3.6};
weapon_factor(10,3) = {3.6};
weapon_factor(10,5) = {3};
%��Ŭ
weapon_factor(11,1) = {'��Ŭ'};
weapon_factor(11,2) = {4.8};
weapon_factor(11,3) = {4.8};
weapon_factor(11,5) = {1};
%��
weapon_factor(12,1) = {'��'};
weapon_factor(12,2) = {3.6};
weapon_factor(12,3) = {3.6};
weapon_factor(12,5) = {1};

%==���� �����͸� ��ġ== 
weapon_factor(:,4) = {0.6};
weapon_factor(5:6,4) = {0.8};
weapon_factor(9:10,4) = {0.9};

%=== ���� ��ų NPM ������ ===
skill_NPM = [
    {'�����','�귣��',95,87,80,0,0,0,0,0}
    {'��ũ����Ʈ','���Ǿ� ������',74,69,66,61,59,0,0,0}
    {'�ȶ��','����Ʈ/����',95,87,0,0,0,0,0,0}
    {'����Ʈ�ε�','Ʈ���ý��ο�',100,0,0,0,0,0,0,0}
    {'������','������',83,0,0,0,0,0,0,0}
    {'��ũ������(��,��)','ü�� ����Ʈ��',87,0,0,0,0,0,0,0}
    {'��ũ������(��,��)','�з�����¡',83,0,0,0,0,0,0,0}
    {'���','��������',74,0,0,0,0,0,0,0}
    {'���츶����','��ǳ�ǽ�',440,440,440,440,440,440,440,440} %��Ż 10% 3��
    {'�ű�','��Ʈ����Ʈ',94,86,82,76,70,0,0,0}
    {'������','�巡�� ��Ʈ����ũ/��ũ���̺�',42,0,0,0,0,0,0,0}
    {'ĸƾ','��Ʋ��:ĳ��',100,96,0,0,0,0,0,0}
];

%=== ������ų ===
%���� ��ų
buff0 = [ {'����', '������ ���', 1.15} ];
buff1 = [ 
    {'��ũ������(��,��)', '������Ʈ ���ø����̼�', 1.5}
    {'��ũ������(��,��)', '������Ʈ ���ø����̼�', 1.5}
    {'�����', '���꽺�� �޺�', 1.9}
    {'��ũ����Ʈ', '����ũ', 2.1}
    {'����Ʈ�ε�', '��������Ʈ��', 1.6}
    {'�ű�', '��Ż��ο�', 2}
    {'ĸƾ', '���꽺�� ȣ��', 1.2}
    ]; 

%���ݷ�/���� �߰� ��ų
buff2 = [ 
    {'�����','�г�',40}
    {'�����','�η�����',50}
    {'��ũ����Ʈ','�巡�� ����',40}
    {'���츶����','���쿢����Ʈ',10}
    {'���츶����','����',30}
    {'�ű�','ũ�ν����쿢����Ʈ',10}
    {'������','����������',30}
    {'��ũ������(��,��)','�޵����̼�',20}
    {'��ũ������(��,��)','�޵����̼�',20}
    ];

%=== ���� ��ų ===
%��ġ ��
%
skill = [
    {'�����','�귣��',450,2} 
    {'��ũ����Ʈ','���Ǿ� ������',250,4} 
    {'�ȶ��','����Ʈ',1050,3} 
    {'����Ʈ�ε�','Ʈ���ý��ο�',300,4}
    {'������','������',235,6}
    {'��ũ������(��,��)','ü�� ����Ʈ��',240,4}
    {'��ũ������(��,��)','�з�����¡',240,4}
    {'���','��������',240,2}
    {'���츶����','��ǳ�ǽ�',300,1}
    {'�ű�','��Ʈ����Ʈ',200,6}
    {'������','�巡�� ��Ʈ����ũ/��ũ���̺�',3150,1}
    {'ĸƾ','��Ʋ��:ĳ��',500,5} 
    ];
%}


one_hit_skill_dmg(:,2) = skill(:,2); %��� ��ų �Է�
%% �Է°� ��� �ɷ�ġ ��� 
%=== �⺻ ũ��Ƽ�� Ȯ��/�߰� ũ��Ƽ�� ������ ===
if question2 > 0
    %���������� ����
    opp = 0.3; %ũ��Ƽ�� Ȯ��
    add_dmg = 50; %�߰� ũ��Ƽ�� ������
    disp('���� ������ ����!');
else
    %���������� ������
    opp = 0; %ũ��Ƽ�� Ȯ��
    add_dmg = 0; %�߰� ũ��Ƽ�� ������ 
end

%�ü��� ��� ��ü ������ ���������� ����ϱ⿡ ���
opp0 = 0.3; %ũ��Ƽ�� Ȯ��
add_dmg0 = 50; %�߰� ũ��Ƽ�� ������

job(:,2) = {0+opp};
job(4,2) = {0.5+opp};
job(9:10,2) = {0.4+opp0}; %�ü��� ���������� ����Ͽ��ٰ� ���

job(:,3) = {100+add_dmg};
job(4,3) = {200+add_dmg};
job(9:10,3) = {200+add_dmg0}; %�ü��� ���������� ����Ͽ��ٰ� ���

%���� ���� ��ġ ����
if question3 > 0
    [a,b] = size(weapon_factor); clear b;
    for ii=1:a 
       weapon_factor(ii,5) = { cell2mat(weapon_factor(ii,5)) - 2 };
       if cell2mat(weapon_factor(ii,5)) <= 0
           weapon_factor(ii,5) = { 1 };
       end
    end
    disp('����ν��� ����!');
end

%������ ��� ���� ������ ����(���� ���,���� �����͸�,���� ���� ���)
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

%ũ��Ƽ�� ��ġ ����� ��ų ������ ��� (������� �������� ����)
[a,b] = size(job); clear b;
for ii=1:a
    if strcmp(cell2mat(skill(ii,1)),'���') || strcmp(cell2mat(skill(ii,1)),'��ũ������(��,��)') || strcmp(cell2mat(skill(ii,1)),'��ũ������(��,��)')
        skill(ii,5) = { cell2mat(job(ii,2)) }; %ũ��Ƽ�� Ȯ��
    else
        skill(ii,5) = { cell2mat(job(ii,2)) }; %ũ��Ƽ�� Ȯ��
        skill(ii,6) = { cell2mat(skill(ii,3)) + cell2mat(job(ii,3)) }; %ũ��Ƽ�� �߰� ������
    end
end

%������ ��ų NPM ����
[a,b] = size(job_weapon_factor); clear b;
for ii=1:a
    jj = cell2mat(job_weapon_factor(ii,6))+2;
    skill(ii,7) = {cell2mat(skill_NPM(ii,jj))};
    
    %�ȶ�� ���
    if strcmp(cell2mat(skill(ii,2)),'����Ʈ/����')
        sNPM = 5; %���� ���� ���� Ƚ��
        skill(ii,7) = { floor(cell2mat(skill_NPM(ii,jj))*(1-sNPM/60)) };
        skill(ii,8) = {sNPM}; 
    end
    
    %������ ���� ���
    if strcmp(cell2mat(skill(ii,1)),'���') || strcmp(cell2mat(skill(ii,1)),'��ũ������(��,��)') || strcmp(cell2mat(skill(ii,1)),'��ũ������(��,��)')
       skill(ii,7) = {cell2mat(skill_NPM(ii,3))};
    end
end

%job_weapon_factor & skill ������ ���� �Ϸ�

%% �ɷ�ġ ���
%���� AP
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

%������ ��� ���� ����
if question1 > 0
    p_ap0 = floor( p_ap0 * cell2mat(buff0(1,3)) );
    disp('������ ��� ����!');
end
    
%������ �޾Ƹ�(4%)/����� ������ �޾Ƹ�(15%)
if question4 == 1
    special_buff = 1.04;
    disp('������ �޾Ƹ� ����!');
elseif question4 == 2
    special_buff = 1.15;
    disp('����� ������ �޾Ƹ� ����!');
else
    special_buff = 1;
end

%% ���� �� ���� ���(���� ���ݷ�)
DPM(:,1) = job(:,1);
[a,b] = size(job); clear b;

for ii=1:a
    str = cell2mat(DPM(ii,1));
    
    %����(������ ����)
    [a,b] = size(buff1); clear b; buff_mul=1;
    for jj=1:a
        if strcmp( cell2mat(buff1(jj,1)), str)
            buff_mul = cell2mat(buff1(jj,3)); 
        end
    end
    
    %����(�߰� ���ݷ�/����)
    [a,b] = size(buff2); clear b;
    phy_ap = phy_mag_ap(ii,1);
    for jj=1:a
        if strcmp( cell2mat(buff2(jj,1)), str)
            phy_ap = phy_ap + cell2mat(buff2(jj,3));
        end
    end
    
    %������ �޾Ƹ� �����(�������ݷ�)
    phy_ap = floor(special_buff*phy_ap); 
    
    %���� ���
    p_ap = p_ap0 + ap(ii,1) + ap_premium;
    s_ap = s_ap0 + ap(ii,2);
    
    %���� ���ݷ� ���    
    phy(:,1) = job(:,1); 
    [a,b] = size(phy); clear b;
    if strcmp('���Ǿ� ������',cell2mat(skill(ii,2)))
        job_weapon_factor(ii,3) = {5};
    end
    phy(ii,2) = { floor( phy_ap/100*( p_ap*cell2mat(job_weapon_factor(ii,3))*0.9*cell2mat(job_weapon_factor(ii,5)) + s_ap ) ) };
    phy(ii,3) = { floor( phy_ap/100*( p_ap*cell2mat(job_weapon_factor(ii,4)) + s_ap ) ) };
    
    %��ų ������ ���
    min = cell2mat(phy(ii,2));
    max = cell2mat(phy(ii,3));
    skill_npm = cell2mat(skill(ii,7));
    skill_fac0 = cell2mat(skill(ii,3));
    skill_hit0 = cell2mat(skill(ii,4)); %��ų 1ȸ Ÿ��
    skill_cri_opp = cell2mat(skill(ii,5)); %ũ�� Ȯ��
    skill_fac1 = cell2mat(skill(ii,6)); %�߰� ũ������ ��� ��ų ���   
    
    skill_hit_1 = skill_hit0*(1-skill_cri_opp)*skill_npm;
    skill_hit_2 = skill_hit0*skill_cri_opp*skill_npm;
    
    skill_min_dmg1 = floor(buff_mul*min*skill_fac0/100);
    skill_min_dmg2 = floor(buff_mul*min*skill_fac1/100);
    skill_max_dmg1 = floor(buff_mul*max*skill_fac0/100);
    skill_max_dmg2 = floor(buff_mul*max*skill_fac1/100);
    
    % �Ƶ� ����
    % - �ű� �Ƶ� ����
    if strcmp(str,'�ű�')
         No_MAX =  No_MAX*2;
    end
    
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
    if strcmp(str,'�ű�')
         No_MAX =  No_MAX/2; % �ٽ� ���� ������ �ǵ�����
    end
    
    %������ ����
    one_hit_skill_dmg(ii,3) = {skill_min_dmg1}; %��ũ��
    one_hit_skill_dmg(ii,4) = {skill_max_dmg1}; %��ũ��
    one_hit_skill_dmg(ii,5) = {skill_min_dmg2}; %ũ��
    one_hit_skill_dmg(ii,6) = {skill_max_dmg2}; %ũ�� 
    
    DPM(ii,2) = { floor( (skill_min_dmg1*skill_hit_1+ skill_min_dmg2*skill_hit_2) ) };
    DPM(ii,3) = { floor( (skill_max_dmg1*skill_hit_1+ skill_max_dmg2*skill_hit_2) ) };
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %���� ���� ��ų ����
    % - ����Ʈ�ε� (Ʈ���� ���ο�)
    if strcmp('����Ʈ�ε�', str)
        %��ü(1Ÿ)
        skill0_min_dmg1 = floor( phy_ap/100*p_ap*2.5*(skill_fac0/100) ); 
        skill0_min_dmg2 = floor( phy_ap/100*p_ap*2.5*(skill_fac1/100) );
        skill0_max_dmg1 = floor( phy_ap/100*p_ap*5.0*(skill_fac0/100) );
        skill0_max_dmg2 = floor( phy_ap/100*p_ap*5.0*(skill_fac1/100) );
        
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
            
        %�׸���(1Ÿ)     
        skill1_min_dmg1 = floor( (buff_mul-1)*skill0_min_dmg1 ); 
        skill1_min_dmg2 = floor( (buff_mul-1)*skill0_min_dmg2 );
        skill1_max_dmg1 = floor( (buff_mul-1)*skill0_max_dmg1 );
        skill1_max_dmg2 = floor( (buff_mul-1)*skill0_max_dmg2 );
            
        %������ ����
        one_hit_skill_dmg(ii,3) = {skill0_min_dmg1}; %��ũ��
        one_hit_skill_dmg(ii,4) = {skill0_max_dmg1}; %��ũ��
        one_hit_skill_dmg(ii,5) = {skill0_min_dmg2}; %ũ��
        one_hit_skill_dmg(ii,6) = {skill0_max_dmg2}; %ũ�� 
    
        DPM(ii,2) = {  floor( (skill0_min_dmg1+skill1_min_dmg1)*skill_hit_1 + (skill0_min_dmg2+skill1_min_dmg2)*skill_hit_2 ) };
        DPM(ii,3) = {  floor( (skill0_max_dmg1+skill1_max_dmg1)*skill_hit_1 + (skill0_max_dmg2+skill1_max_dmg2)*skill_hit_2 ) };
        clear skill0_min_dmg1 skill0_min_dmg2 skill0_max_dmg1 skill0_max_dmg2 skill1_min_dmg1 skill1_min_dmg2 skill1_max_dmg1 skill1_max_dmg2
    end
    
    % - �ȶ�� (����)
    %
    if strcmp('����Ʈ/����', cell2mat(skill(ii,2)))
        crr = (add_dmg+100)/100;
        npmm = cell2mat(skill(ii,8));
        sca1 = floor( buff_mul*skill_cri_opp*crr*(p_ap*400+1200*phy_ap)*55/25);
        sca2 = floor( buff_mul*(1-skill_cri_opp)*(p_ap*400+1200*phy_ap)*55/25);
        if sca1 >= No_MAX
            sca1 = No_MAX-1;
        end
        if sca2 >= No_MAX
            sca2 = No_MAX-1; 
        end
    
        DPM(ii,2) = { cell2mat(DPM(ii,2)) + (sca1 + sca2)*npmm };
        DPM(ii,3) = { cell2mat(DPM(ii,3)) + (sca1 + sca2)*npmm };
        clear crr npmm sca1 sca2;
    end
    %
    
    % - ���츶����
    if strcmp(cell2mat(skill(ii,2)),'��ǳ�ǽ�')
        DPM(ii,2) = { floor( (skill_min_dmg1*skill_hit_1+ skill_min_dmg2*skill_hit_2)*((1-bow1_opp + bow1_opp*bow1_mul)) ) };
        DPM(ii,3) = { floor( (skill_max_dmg1*skill_hit_1+ skill_max_dmg2*skill_hit_2)*((1-bow1_opp + bow1_opp*bow1_mul)) ) };
        clear bow1_opp bow1_mul
    end
    
    % - ������
    if strcmp('������', str)
        %�巡��Ʈ����ũ 1Ÿ(450�� 3�� 8����)
        skill_fac0 = skill_ds;
        skill_fac1 = skill_ds + 100 + add_dmg;
        skill1_min_dmg1 = floor(buff_mul*min*skill_fac0/100);
        skill1_min_dmg2 = floor(buff_mul*min*skill_fac1/100);
        skill1_max_dmg1 = floor(buff_mul*max*skill_fac0/100);
        skill1_max_dmg2 = floor(buff_mul*max*skill_fac1/100);
        
        %��ũ���̺� 1Ÿ(900�� 2Ÿ 6����)
        skill_fac0 = skill_sw;
        skill_fac1 = skill_sw + 100+ add_dmg;
        skill2_min_dmg1 = floor(buff_mul*min*skill_fac0/100);
        skill2_min_dmg2 = floor(buff_mul*min*skill_fac1/100);
        skill2_max_dmg1 = floor(buff_mul*max*skill_fac0/100);
        skill2_max_dmg2 = floor(buff_mul*max*skill_fac1/100);

        % �Ƶ� ����
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
        
        %������ ����
        one_hit_skill_dmg(ii,3) = {skill1_min_dmg1}; %��ũ��
        one_hit_skill_dmg(ii,4) = {skill1_max_dmg1}; %��ũ��
        one_hit_skill_dmg(ii,5) = {skill1_min_dmg2}; %ũ��
        one_hit_skill_dmg(ii,6) = {skill1_max_dmg2}; %ũ��
        
        one_hit_skill_dmg(ii,7) = {skill2_min_dmg1}; %��ũ��
        one_hit_skill_dmg(ii,8) = {skill2_max_dmg1}; %��ũ��
        one_hit_skill_dmg(ii,9) = {skill2_min_dmg2}; %ũ��
        one_hit_skill_dmg(ii,10) = {skill2_max_dmg2}; %ũ��
    
        DPM(ii,2) = {  floor( (skill1_min_dmg1*npm_ds+skill2_min_dmg1*npm_sw)*skill_hit_1 + (skill1_min_dmg2*npm_ds+skill2_min_dmg2*npm_sw)*skill_hit_2 ) };
        DPM(ii,3) = {  floor( (skill1_max_dmg1*npm_ds+skill2_max_dmg1*npm_sw)*skill_hit_1 + (skill1_max_dmg2*npm_ds+skill2_max_dmg2*npm_sw)*skill_hit_2 ) };
        clear  skill_ds skill_sw npm_ds npm_sw;
        clear  skill1_min_dmg1 skill1_min_dmg2 skill1_max_dmg1 skill1_max_dmg2;
        clear  skill2_min_dmg1 skill2_min_dmg2 skill2_max_dmg1 skill2_max_dmg2;
    end
end

%% ���� �� ���� ���(���� ���ݷ�)
[a,b] = size(job); clear b;
for ii=6:8
    str = cell2mat(DPM(ii,1));
    
    %����(������ ����)
    [a,b] = size(buff1); clear b; buff_mul=1;
    for jj=1:a
        if strcmp( cell2mat(buff1(jj,1)), str)
            buff_mul = cell2mat(buff1(jj,3)); 
        end
    end
    
    %����(�߰� ����)
    [a,b] = size(buff2); clear b;
    mag_ap = phy_mag_ap(ii,1);
    for jj=1:a
        if strcmp( cell2mat(buff2(jj,1)), str)
            mag_ap = mag_ap + cell2mat(buff2(jj,3)); 
        end
    end
        
    %���� ���
    p_ap = floor(p_ap0) + ap(ii,1) +  ap_premium;
    
    %��ų ������ ���
    skill_npm = cell2mat(skill(ii,7));
    skill_hit0 = cell2mat(skill(ii,4));
    skill_cri_opp = cell2mat(skill(ii,5)); %ũ�� Ȯ��
    skill_fac1 = (add_dmg+100)/100; %ũ��Ƽ�� ���� ��� ��ų ������ ���� ��� (������ Ư��)
    
    skill_hit_1 = skill_hit0*(1-skill_cri_opp)*skill_npm;
    skill_hit_2 = skill_hit0*skill_cri_opp*skill_npm;
    
    %��ų 1Ÿ ������
    %��ũ��
    min0 = floor( buff_mul*((0.0033665*(special_buff*(p_ap+mag_ap))^2 + 3.3*(special_buff*(p_ap+mag_ap))*0.9*0.6 + 0.5*p_ap)*cell2mat(skill(ii,3))/100) ); %1Ÿ ������
    max0 = floor( buff_mul*((0.0033665*(special_buff*(p_ap+mag_ap))^2 + 3.3*(special_buff*(p_ap+mag_ap)) + 0.5*p_ap)*cell2mat(skill(ii,3))/100) ); %1Ÿ ������
    %ũ��
    min1 = floor( skill_fac1*buff_mul*((0.0033665*(special_buff*(p_ap+mag_ap))^2 + 3.3*(special_buff*(p_ap+mag_ap))*0.9*0.6 + 0.5*p_ap)*cell2mat(skill(ii,3))/100) ); %1Ÿ ������
    max1 = floor( skill_fac1*buff_mul*((0.0033665*(special_buff*(p_ap+mag_ap))^2 + 3.3*(special_buff*(p_ap+mag_ap)) + 0.5*p_ap)*cell2mat(skill(ii,3))/100) ); %1Ÿ ������
    
    %�Ƶ� ����
    if min0 >= No_MAX
        min0 = No_MAX-1;
    end
    if max0 >= No_MAX
        max0 = No_MAX-1;
    end 
    if min1 >= No_MAX
        min1 = No_MAX-1;
    end
    if max1 >= No_MAX
        max1 = No_MAX-1;
    end 
    
    %������ ����
    one_hit_skill_dmg(ii,3) = {min0}; %��ũ��
    one_hit_skill_dmg(ii,4) = {max0}; %��ũ��
    one_hit_skill_dmg(ii,5) = {min1}; %ũ��
    one_hit_skill_dmg(ii,6) = {max1}; %ũ�� 
    
    DPM(ii,2) = {min0*skill_hit_1 + min1*skill_hit_2};
    DPM(ii,3) = {max0*skill_hit_1 + max1*skill_hit_2};
end
 
%% ���� ���� (��� ���� DPM ����)
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
   DPM_rank(ii,1) = DPM(k,1);
   
   DPM_rank(ii,2) = phy(k,2);
   DPM_rank(ii,3) = phy(k,3);
   
   DPM_rank(ii,4) = one_hit_skill_dmg(k,3);
   DPM_rank(ii,5) = one_hit_skill_dmg(k,4);
end
for ii=1:a
    DPM_rank(ii,6) = { cell2mat(DPM_rank(ii,6))/10^8 };
end