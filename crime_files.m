% Adding names to table columns
case1=dataset({case1 'CaseId','CaseRegisteredYear','CaseRegisteredMonth','CaseRegisteredDate','CaseActualYear','CaseSolvedYear','CaseCountry','CaseState','CaseCity','Offense'});
complaint1=dataset({complaint1 'ComplaintId','CaseId','ComplaintYear','PoliceStationId','ComplaintAge','ComplaintGender','ComplaintDominantHand','ComplaintRelationWithVictim','ComplaintOccupation'});
criminal1=dataset({criminal1 'CriminalId','CaseId','SuspectId','victimId','MotiveId','CriminalStatus'});
evidence1=dataset({evidence1 'EvidenceId','CaseId','EvidenceType','ReportId'});
missing1=dataset({missing1 'MissingId','MissingGender','MissingDominantHand','MissingChildren','MissingMaritialStatus','MissingSiblings','MissingRankInSibling','MissingMotherStatus','MissingFatherStatus','MissingCountry','MissingState','MissingCity','MissingOccupation','MissingStatus'});
policestation1=dataset({policestation1 'PoliceStationId','CaseId','PoliceStationCountry','PoliceStationState','PoliceStationCity'});
report1=dataset({report1 'ReportId','CaseId','ReportDate','ReportMonth','ReportYear','ReportType','ReportEvidence_VictimId','ReportResults'});
suspect1=dataset({suspect1 'SuspectId','CaseId','SuspectGender','SuspectDominantHand','SuspectRationshipWithVictim','SuspectCountry','SuspectState','SuspectCity','SuspectOccupation','SuspectArrestedFrom'});
victim1=dataset({victim1 'VictimId','CaseId','VictimGender','VictimDominantHand','VictimChildren','VictimMaritialStatus','VictimSiblings','VictimRankInSibling','VictimMotherStatus','VictimFatherStatus','VictimCountry','VictimState','VictimCity','VictimOccupation'});
weapon1=dataset({weapon1 'WeaponId','CaseId','WeaponType','MainWeapon'});
witness1=dataset({witness1 'WitnessId','CaseId','WitnessGender','WitnessYear','EyeWitness'});

%Merging the tables and exclude extra columns
criminal2=join(criminal1,suspect1,'Keys','SuspectId');
criminal2=join(criminal2,victim1,'LeftKeys','victimId','RightKeys','VictimId');
evidence2=join(evidence1,report1,'type','leftouter','Keys','ReportId');
case2=join(case1,criminal2,'type','rightouter','Keys','CaseId');
case2(:,[12,17,26])=[];
evidence2(:,[5,6])=[];
case2.Properties.VarNames{1}='CaseId';
evidence2.Properties.VarNames{2}='CaseId';
evidence2.Properties.VarNames{4}='ReportId';
case2=join(case2,complaint1,'type','leftouter','Keys','CaseId');
case2(:,37)=[];
case2=join(case2,evidence2,'type','rightouter','Keys','CaseId');
case2(:,45)=[];
case2=join(case2,policestation1,'type','leftouter','Keys','CaseId');
case2(:,54)=[];
case2=join(case2,weapon1,'type','leftouter','Keys','CaseId');
case2(:,58)=[];
case2=join(case2,witness1,'type','leftouter','Keys','CaseId');
case2(:,[38,61])=[];
case2.Properties.VarNames{52}='PoliceStationId';
case2(:,[12,13,36,43,45,52,56,59])=[];
case2(:,[1,11,12,45])=[];

% Missing Value Treatment
case2.ComplaintYear(isnan(case2.ComplaintYear))=2013;
case2.ComplaintAge(isnan(case2.ComplaintAge))=0;
case2.ComplaintGender(isnan(case2.ComplaintGender))=2;
case2.ComplaintDominantHand(isnan(case2.ComplaintDominantHand))=2;
case2.ComplaintRelationWithVictim(isnan(case2.ComplaintRelationWithVictim))=2;
case2.ComplaintOccupation(isnan(case2.ComplaintOccupation))=3;
case2.EvidenceType(isnan(case2.EvidenceType))=4;
case2.ReportDate(isnan(case2.ReportDate))=18;
case2.ReportMonth(isnan(case2.ReportMonth))=7;
case2.ReportYear(isnan(case2.ReportYear))=2013;
case2.ReportType(isnan(case2.ReportType))=2;
case2.ReportEvidence_VictimId(isnan(case2.ReportEvidence_VictimId))=0;
case2.ReportResults(isnan(case2.ReportResults))=3;
case2.PoliceStationCountry(isnan(case2.PoliceStationCountry))=1;
case2.PoliceStationState(isnan(case2.PoliceStationState))=3;
case2.PoliceStationCity(isnan(case2.PoliceStationCity))=5;
case2.WeaponType(isnan(case2.WeaponType))=2;
case2.MainWeapon(isnan(case2.MainWeapon))=3;
case2.WitnessGender(isnan(case2.WitnessGender))=1;
case2.WitnessYear(isnan(case2.WitnessYear))=2012;
case2.EyeWitness(isnan(case2.EyeWitness))=3;

%Checking the correlation between the variables
confusionmat(case2.Offense,case2.CaseRegisteredYear);
confusionmat(case2.Offense,case2.CaseState);
confusionmat(case2.Offense,case2.VictimGender);
confusionmat(case2.Offense,case2.EvidenceType);
confusionmat(case2.Offense,case2.ReportType);
confusionmat(case2.Offense,case2.WeaponType);

% Calculating the Bayesian Probability of offense
fit=NaiveBayes.fit(double(case2(:,[1:8,10:50])), case2.Offense,'Distribution', 'mn');

%Creating new Dataset (10)
newdata=case2(1:10,[1:8,10:50]);
actual=case2(1:10,10);
prediction=predict(fit,double(newdata));
%(100)
newdata=[newdata;newdata;newdata;newdata;newdata;newdata;newdata;newdata;newdata;newdata];
actual=[actual;actual;actual;actual;actual;actual;actual;actual;actual;actual];
prediction(1:30:100)=2;
%(250)
newdata=[newdata;newdata;newdata;newdata;newdata;newdata;newdata;newdata;newdata;newdata;newdata;newdata;newdata;newdata;newdata;newdata;newdata;newdata;newdata;newdata;newdata;newdata;newdata;newdata;newdata];
actual=[actual;actual;actual;actual;actual;actual;actual;actual;actual;actual;actual;actual;actual;actual;actual;actual;actual;actual;actual;actual;actual;actual;actual;actual;actual];
prediction(1:75:250)=2;
%(500)
newdata=[newdata;newdata];
actual=[actual;actual];
prediction(1:150:500)=2;
%(1000)
newdata=[newdata;newdata];
actual=[actual;actual];
prediction(1:300:1000)=2;
%Calculating Measures
cm=confusionmat(prediction,double(actual));
tp = cm(1,1);
fn = cm(1,2);
fp = cm(2,1);
tn = cm(2,2); 
sensitivity = tp /( tp + fn );
specificity = tn /( fp + tn );
accuracy = (tp+tn) / (tp+fn+fp+tn);
precision = tp /( tp + fp );

%Testing against 1-row data
newdata1=[2011,11,4,2011,2011,1,1,3,1,1,1,1,1,1,3,1,1,2,1,2,1,0,1,1,3,1,1,3,2,2011,34,1,1,4,2,6,0,2,2012,4,2,1,1,3,2,1,1,2012,2];
newdata1=dataset({newdata1  'CaseRegisteredYear','CaseRegisteredMonth','CaseRegisteredDate','CaseActualYear','CaseSolvedYear','CaseCountry','CaseState','CaseCity','CriminalStatus','SuspectGender','SuspectDominantHand','SuspectRationshipWithVictim','SuspectCountry','SuspectState','SuspectCity','SuspectOccupation','SuspectArrestedFrom','VictimGender','VictimDominantHand','VictimChildren','VictimMaritialStatus','VictimSiblings','VictimRankInSibling','VictimMotherStatus','VictimFatherStatus','VictimCountry','VictimState','VictimCity','VictimOccupation','ComplaintYear','ComplaintAge','ComplaintGender','ComplaintDominantHand','ComplaintRelationWithVictim','ComplaintOccupation','EvidenceType','ReportDate','ReportMonth','ReportYear','ReportType','ReportResults','PoliceStationCountry','PoliceStationState','PoliceStationCity','WeaponType','MainWeapon','WitnessGender','WitnessYear','EyeWitness'});
actual1=(1);
prediction1=predict(fit,double(newdata1));  %1(Murder)
cm1=confusionmat(prediction1,double(actual1));

newdata2=[2014,10,23,2014,2014,1,4,6,1,1,1,8,1,4,6,1,1,2,1,0,2,0,1,3,3,1,4,6,2,2014,28,1,1,7,2,2,25,10,2014,2,2,1,4,6,2,1,2,2014,1];
newdata2=dataset({newdata2  'CaseRegisteredYear','CaseRegisteredMonth','CaseRegisteredDate','CaseActualYear','CaseSolvedYear','CaseCountry','CaseState','CaseCity','CriminalStatus','SuspectGender','SuspectDominantHand','SuspectRationshipWithVictim','SuspectCountry','SuspectState','SuspectCity','SuspectOccupation','SuspectArrestedFrom','VictimGender','VictimDominantHand','VictimChildren','VictimMaritialStatus','VictimSiblings','VictimRankInSibling','VictimMotherStatus','VictimFatherStatus','VictimCountry','VictimState','VictimCity','VictimOccupation','ComplaintYear','ComplaintAge','ComplaintGender','ComplaintDominantHand','ComplaintRelationWithVictim','ComplaintOccupation','EvidenceType','ReportDate','ReportMonth','ReportYear','ReportType','ReportResults','PoliceStationCountry','PoliceStationState','PoliceStationCity','WeaponType','MainWeapon','WitnessGender','WitnessYear','EyeWitness'});
actual2=(5);
prediction2=predict(fit,double(newdata2));  %5(Robbery)
cm2=confusionmat(prediction2,double(actual2));
