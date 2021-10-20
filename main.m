%define nodes
Difficulty=1;Accuracy=2;Time=3;NeedHelp=4;Confused=5;
%create dag
dag = zeros(5,5);
dag(Difficulty,[Accuracy, Time, NeedHelp]) = 1;
dag(NeedHelp, Confused) = 1;
% we have 5 nodes, 4 have 2 values, one has 3 possbile values
ns = 2*ones(1,5);
ns(3) = 3;
% create bayes net
bnet = mk_bnet(dag, ns);

% add CPT for Difficulty which has uniform distribution
bnet.CPD{Difficulty} = tabular_CPD(bnet, Difficulty, 'CPT', [0.5 0.5]);

% reading from files
avgs = read_files();
easy_avg_correct = avgs(1);
hard_avg_correct = avgs(2);

time_probs = time_probability();
%easy hard
%[Pr_slow,Pr_fast,Pr_avg] 
easy_slow = time_probs(1);
easy_fast = time_probs(2);
easy_avg = time_probs(3);
hard_slow = time_probs(4);
hard_fast = time_probs(5);
hard_avg = time_probs(6);


%Pr(Accuracy=right|Difficulty=easy) = easy_avg_correct
%Pr(Accuracy=right|Difficulty=hard) = hard_avg_correct

%indices of responses
Right = 1; Wrong = 2;
CPT = zeros(2,2);
CPT(1,:) = [easy_avg_correct, 1-easy_avg_correct];
CPT(2, :) = [hard_avg_correct, 1-hard_avg_correct];
bnet.CPD{Accuracy}=tabular_CPD(bnet, Accuracy, 'CPT', CPT);

%Pr(Time=slow|Difficulty=easy) = easy_slow
%Pr(Time=avg|Difficulty=easy) = easy_avg
%Pr(Time=fast|Difficulty=easy) = easy_fast
%Pr(Time=slow|Difficulty=hard) = hard_slow
%Pr(Time=avg|Difficulty=hard) = hard_avg
%Pr(Time=fast|Difficulty=hard) = hard_fast

%indices of responses
Slow = 1; Avg = 2; Fast = 3;
CPT = zeros(2,3);
CPT(1,:) = [easy_slow, easy_avg, easy_fast];
CPT(2, :) = [hard_slow, hard_avg, hard_fast];
bnet.CPD{Time}=tabular_CPD(bnet, Time, 'CPT', CPT);

%Pr(NeedHelp|Easy) = 0.2
%Pr(NeedHelp|Hard) = 0.6
%The problems are not defined as hard or easy by the user so you may still
%need help with an easy question. But you will need more help with an hard
%question because they are designed to be more defficult. Since I can't see
%the question I used the accuracy and time to determine the help needed.
%The hard questions take much longer (about 5 times as long) but the
%accuracy is only slightly lower. For this reason I made the hard questions
%only slightly in favour of asking of needing help, and the easy questions
%strongly in favour of not needing help

%indices of responses
True = 1; False = 2;
CPT = zeros(2,2);
CPT(1,:) = [0.2, 0.8];
CPT(2, :) = [0.6, 0.4];
bnet.CPD{NeedHelp}=tabular_CPD(bnet, NeedHelp, 'CPT', CPT);

% Pr(Confused|NeedHelp=False) = 0.1
% Pr(Confused|NeedHelp=True) = 0.75
%If you do not need help, there is a possibility that you are still
%confused but are able to solve the problem still (via googling, re-reading
%the question, thinking more etc), however it is unlikely, most people who
%are confused would like help if it is avalible. If you do need help, it is
%likely you are confused, however you might also just have forgotten
%something, such as a formula, that you need to be reminded of. I think its
%more likely if you need help you are confused.

%indices of responses
True = 1; False = 2;
CPT = zeros(2,2);
CPT(1,:) = [0.1, 0.9];
CPT(2, :) = [0.75, 0.25];
bnet.CPD{Confused}=tabular_CPD(bnet, Confused, 'CPT', CPT);


% create inference engine for that BN
engine = jtree_inf_engine(bnet);
% define variable for entering evidence
ev = cell(1,5);
% C is observed to be true (index 2)
ev{Confused} = True;
ev{Accuracy} = Right;
ev{Time} = Fast;
engine = enter_evidence(engine, ev);
% compute the marginal over the variable B
m = marginal_nodes(engine, NeedHelp);
% display the true value (at index 2) of the marginal
fprintf('P(NeedHelp=true|Confused=true, Accuracy=true, Time=fast) = %5.3f\n', m.T(1))


