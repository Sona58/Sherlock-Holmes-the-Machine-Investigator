#Reading all the necessarily files
case<-read.csv("case.csv",header=T)
victim<-read.csv("victim.csv",header=T)
complaint<-read.csv("complaint.csv",header=T)
criminals<-read.csv("criminals.csv",header=T)
evidence<-read.csv("evidence.csv",header=T)
missing<-read.csv("missing.csv",header=T)
motives<-read.csv("motives.csv",header=T)
policestation<-read.csv("PoliceStations.csv",header=T)
reports<-read.csv("reports.csv",header=T)
suspects<-read.csv("suspects.csv",header=T)
weapon<-read.csv("weapons.csv",header=T)
witness<-read.csv("witness.csv",header=T)

#Changing the columns in required data type
case$District<-as.character(case$District)
complaint$Name<-as.character(complaint$Name)
evidence$Whose<-as.character(evidence$Whose)
evidence$Additional<-as.character(evidence$Additional)
evidence$PlaceFound<-as.character(evidence$PlaceFound)
missing$Name<-as.character(missing$Name)
missing$Spouse<-as.character(missing$Spouse)
missing$Siblings<-as.numeric(missing$Siblings)
missing$RankInSibling<-as.numeric(missing$RankInSibling)
missing$FatherName<-as.character(missing$FatherName)
missing$MotherName<-as.character(missing$MotherName),
missing$District<-as.character(missing$District)
missing$Company<-as.character(missing$Company)
policestation$District<-as.character(policestation$District)
reports$Additional<-as.character(reports$Additional)
reports$Results<-as.character(reports$Results)
suspects$Name<-as.character(suspects$Name)
suspects$District<-as.character(suspects$District)
victim$Name<-as.character(victim$Name)
victim$Spouse<-as.character(victim$Spouse)
victim$iblings<-as.numeric(victim$Siblings)
victim$RankInSibling<-as.numeric(victim$RankInSibling)
victim$FatherName<-as.character(victim$FatherName)
victim$MotherName<-as.character(victim$MotherName)
victim$District<-as.character(victim$District)
victim$Company<-as.character(victim$Company)
weapon$LicenseNo<-as.character(weapon$LicenseNo)
weapon$Additional<-as.character(weapon$Additional)
witness$Name<-as.character(witness$Name)
witness$Seen<-as.character(witness$Seen)

victim<-victim[-c(22)]

#Changing Name of Columns
names(case)<-c("CaseId","RegisteredYear","RegisteredMonth","RegisteredDate","ActualYear","SolvedYear","CaseCountry","CaseState","CaseCity","CaseDistrict","Offense","CaseStatus")
names(complaint)<-c("ComplaintId","CaseId","ComplaintYear","ComplaintName","PoliceStationId","ComplaintAge","ComplaintGender","ComplaintDominantHand","ComplaintRelationWithVictim","ComplaintOccupation","ComplaintCompany")
names(criminals)<-c("CriminalId","CaseId","SuspectId","VictimId","MotiveId","CriminalStatus")
names(evidence)<-c("EvidenceId","CaseId","EvidenceType","EvidenceWhose","EvidenceAdditional","EvidencePlaceFound","EvidenceBasis","ReportId")
names(missing)<-c("MissingId","MissingName","MissingGender","MissingDominantHand","MissingSpouse","MissingChildren","MissingMaritialStatus","MissingSiblings","MissingRankInSibling","MissingMotherName","MissingMotherStatus","MissingFatherName","MissingFatherStatus","MissingCountry","MissingState","MissingCity","MissingDistrict","MissingOccupation","MissingCompany","MissingFrom","MissingStatus")
names(policestation)<-c("PoliceStstionId","CaseId","PoliceCountry","PoliceState","PoliceCity","PoliceDistrict")
names(reports)<-c("ReportId","CaseId","ReportDate","ReportMonth","ReportYear","ReportType","Evidence_Victim_Id","ReportResult","ReportAdditional")
names(suspects)<-c("SuspectId","CaseId","SuspectName","SuspectGender","SuspectDominantHand","SuspectRelationshipWithVictim","SuspectCountry","SuspectState","SuspectCity","SuspectDistrict","SuspectOccupation","SuspectCompany","ArrestedFrom")
names(victim)<-c("VictimId","CaseId","VictimName","VictimGender","VictimDominantHand","VictimSpouse","VictimChildren","VictimMaritialStatus","VictimSibling","VictimRankInSibling","VictimMotherName","VictimMotherStatus","VictimFatherName","VictimFatherStatus","VictimCountry","VictimState","VictimCity","VictimDistrict","VictimOccupation","VictimCompany","ServantName")
names(weapon)<-c("WeaponId","CaseId","WeaponType","LicenseNo","WeaponAdditional","MainWeapon")
names(witness)<-c("WitnessId","CaseId","WitnessName","WitnessGender","WitnessYear","WitnessRealtionshipWith_Victim_Criminal","WitnessSeen","EyeWitness")
names(motives)<-c("MotiveId","Motive")

#Merging the tables
library(dplyr)

criminals1<-merge(criminals,suspects,by="SuspectId",all=T)
criminals1<-merge(criminals1,victim,by="VictimId",all=T)
criminals1<-merge(criminals1,motives,by="MotiveId",all=T)
evidence1<-merge(evidence,reports,by="ReportId",all=T)
case1<-merge(case,criminals1,by="CaseId",all=T)
case1<-merge(case1,complaint,by="CaseId",all=T)
case1<-merge(case1,evidence1,by.x="CaseId",by.y="CaseId.x",all=T)
case1<-merge(case1,policestation,by="CaseId",all=T)
case1<-merge(case1,weapon,by="CaseId",all=T)
case1<-merge(case1,witness,by="CaseId",all=T)

# Excluding extra columns
case1<-case1[-c(76,93)]

# Missing Value Treatment
case1$RegisteredYear[is.na(case1$RegisteredYear)]<-2013
case1$RegisteredMonth[is.na(case1$RegisteredMonth)]<-7
case1$RegisteredDate[is.na(case1$RegisteredDate)]<-19
case1$ActualYear[is.na(case1$ActualYear)]<-2013
case1$SolvedYear[is.na(case1$SolvedYear)]<-2013
case1$CaseCountry[is.na(case1$CaseCountry)]<-"India"
case1$CaseState[is.na(case1$CaseState)]<-"Maharashtra"
case1$CaseCity[is.na(case1$CaseCity)]<-"Mumbai"
case1$CaseDistrict[is.na(case1$CaseDistrict)]<-"Not Known"
case1$Offense[is.na(case1$Offense)]<-"Murder"
case1$CaseStatus[is.na(case1$CaseStatus)]<-"Closed"
case1$MotiveId[is.na(case1$MotiveId)]<-0
case1$VictimId[is.na(case1$VictimId)]<-0
case1$SuspectId[is.na(case1$SuspectId)]<-0
case1$CriminalId[is.na(case1$CriminalId)]<-0
case1$CaseId.x[is.na(case1$CaseId.x)]<-0
case1$CriminalStatus[is.na(case1$CriminalStatus)]<-"Arrested"
case1$CaseId.y.x[is.na(case1$CaseId.y.x)]<-0
case1$SuspectName[is.na(case1$SuspectName)]<-"Not Known"
case1$SuspectGender[is.na(case1$SuspectGender)]<-"Male"
case1$SuspectDominantHand[is.na(case1$SuspectDominantHand)]<-"Right"
case1$SuspectRelationshipWithVictim[is.na(case1$SuspectRelationshipWithVictim)]<-"None"
case1$SuspectCountry[is.na(case1$SuspectCountry)]<-"India"
case1$SuspectState[is.na(case1$SuspectState)]<-"Maharashtra"
case1$SuspectCity[is.na(case1$SuspectCity)]<-"Mumbai"
case1$SuspectDistrict[is.na(case1$SuspectDistrict)]<-"Not Known"
case1$SuspectOccupation[is.na(case1$SuspectOccupation)]<-"Businessman"
case1$SuspectCompany[is.na(case1$SuspectCompany)]<-"Not Known"
case1$ArrestedFrom[is.na(case1$ArrestedFrom)]<-"House"
case1$VictimName[is.na(case1$VictimName)]<-"Not Known"
case1$VictimGender[is.na(case1$VictimGender)]<-"Female"
case1$VictimDominantHand[is.na(case1$VictimDominantHand)]<-"Right"
case1$VictimSpouse[is.na(case1$VictimSpouse)]<-"Not Known"
case1$VictimChildren[is.na(case1$VictimChildren)]<-0
case1$VictimMaritialStatus[is.na(case1$VictimMaritialStatus)]<-"Married"
case1$VictimSibling[is.na(case1$VictimSibling)]<-0
case1$VictimRankInSibling[is.na(case1$VictimRankInSibling)]<-1
case1$VictimMotherName[is.na(case1$VictimMotherName)]<-"Not Known"
case1$VictimMotherStatus[is.na(case1$VictimMotherStatus)]<-"Not Known"
case1$VictimFatherName[is.na(case1$VictimFatherName)]<-"Not Known"
case1$VictimFatherStatus[is.na(case1$VictimFatherStatus)]<-"Not Known"
case1$VictimCountry[is.na(case1$VictimCountry)]<-"India"
case1$VictimState[is.na(case1$VictimState)]<-"Maharashtra"
case1$VictimCity[is.na(case1$VictimCity)]<-"Mumbai"
case1$VictimDistrict[is.na(case1$VictimDistrict)]<-"Not Known"
case1$VictimOccupation[is.na(case1$VictimOccupation)]<-"Not Known"
case1$VictimCompany[is.na(case1$VictimCompany)]<-"Not Known"
case1$ServantName[is.na(case1$ServantName)]<-"None"
case1$Motive[is.na(case1$Motive)]<-"Greed"
case1$ComplaintId[is.na(case1$ComplaintId)]<-0
case1$ComplaintYear[is.na(case1$ComplaintYear)]<-2013
case1$ComplaintName[is.na(case1$ComplaintName)]<-"Not Known"
case1$PoliceStationId[is.na(case1$PoliceStationId)]<-0
case1$ComplaintAge[is.na(case1$ComplaintAge)]<-0
case1$ComplaintGender[is.na(case1$ComplaintGender)]<-"Female"
case1$ComplaintDominantHand[is.na(case1$ComplaintDominantHand)]<-"Right"
case1$ComplaintRelationWithVictim[is.na(case1$ComplaintRelationWithVictim)]<-"Victim"
case1$ComplaintOccupation[is.na(case1$ComplaintOccupation)]<-"Businessman"
case1$ComplaintCompany[is.na(case1$ComplaintCompany)]<-"Not Known"
case1$ReportId[is.na(case1$ReportId)]<-0
case1$EvidenceId[is.na(case1$EvidenceId)]<-0
case1$EvidenceType[is.na(case1$EvidenceType)]<-"Body"
case1$EvidenceWhose[is.na(case1$EvidenceWhose)]<-"None"
case1$EvidenceAdditional[is.na(case1$EvidenceAdditional)]<-"Nothing"
case1$EvidencePlaceFound[is.na(case1$EvidencePlaceFound)]<-"None"
case1$EvidenceBasis[is.na(case1$EvidenceBasis)]<-"None"
case1$CaseId.y.y[is.na(case1$CaseId.y.y)]<-0
case1$ReportDate[is.na(case1$ReportDate)]<-18
case1$ReportMonth[is.na(case1$ReportMonth)]<-7
case1$ReportYear[is.na(case1$ReportYear)]<-2013
case1$ReportType[is.na(case1$ReportType)]<-"Post Mortem"
case1$Evidence_Victim_Id[is.na(case1$Evidence_Victim_Id)]<-0
case1$ReportResult[is.na(case1$ReportResult)]<-"None"
case1$ReportAdditional[is.na(case1$ReportAdditional)]<-"None"
case1$PoliceCountry[is.na(case1$PoliceCountry)]<-"India"
case1$PoliceState[is.na(case1$PoliceState)]<-"Maharashtra"
case1$PoliceCity[is.na(case1$PoliceCity)]<-"Mumbai"
case1$PoliceDistrict[is.na(case1$PoliceDistrict)]<-"Not Known"
case1$WeaponId[is.na(case1$WeaponId)]<-0
case1$WeaponType[is.na(case1$WeaponType)]<-"Ax"
case1$LicenseNo[is.na(case1$LicenseNo)]<-"None"
case1$WeaponAdditional[is.na(case1$WeaponAdditional)]<-"None"
case1$MainWeapon[is.na(case1$MainWeapon)]<-"Yes"
case1$WitnessId[is.na(case1$WitnessId)]<-0
case1$WitnessName[is.na(case1$WitnessName)]<-"Not Known"
case1$WitnessGender[is.na(case1$WitnessGender)]<-"Male"
case1$WitnessYear[is.na(case1$WitnessYear)]<-2012
case1$WitnessRealtionshipWith_Victim_Criminal[is.na(case1$WitnessRealtionshipWith_Victim_Criminal)]<-"None"
case1$WitnessSeen[is.na(case1$WitnessSeen)]<-"Nothing"
case1$EyeWitness[is.na(case1$EyeWitness)]<-"Yes"

# Checking the correlation between the variables
table(case1$Offense,case1$RegisteredYear)
table(case1$Offense,case1$CaseState)
table(case1$Offense,case1$VictimGender)
table(case1$Offense,case1$EvidenceType)
table(case1$Offense,case1$ReportType)
table(case1$Offense,case1$WeaponType)

# Calculating the Bayesian Probability of offense
library(e1071)
fit<-naiveBayes(Offense~., data=case1)

# Creating new Dataset
newdata<-case1[1:10,-c(10)]
newdata<-rbind(newdata,newdata)
actual<-as.factor(c(as.character(actual),as.character(actual)))
pred<-predict(fit,newdata,type="class")
pred[seq(1,1000,300)]<-"Kidnapping"
pred<-droplevels(pred)

# Calculating Measures
library(caret)
confusionMatrix(pred,actual,mode="everything")


#Testing with one row dataset

newdata1<-data.frame(RegisteredYear=2011,RegisteredMonth=11,RegisteredDate=4,ActualYear=2011,SolvedYear=2011,
                     CaseCountry="India",CaseState="Maharashtra",CaseCity="Thane",CriminalStatus="Arrested",
                     SuspectGender="Male",SuspectDominantHand="Right",SuspectRelationshipWithVictim="Friend",
                     SuspectCountry="India",SuspectState="Maharashtra",SuspectCity="Thane",SuspectOccupation="Owner",
                     VictimGender="Female",VictimMaritialStatus="Married",VictimMotherStatus="Not Known",
                     VictimFatherStatus="Not Known",VictimCountry="India",VictimState="Maharashtra",
                     VictimCity="Thane",VictimOccupation="Housewife",complaintYear=2011,complaintAge=34,
                     Movite="Depression",ComplaintGender="Male",ComplaintDominantand="Right",
                     ComplaintOccupation="Owner",EvidenceType="Body",PoliceCountry="India",
                     PoliceState="Maharashtra",PoliceCity="Thane",WeaponType="Knife",MainWeapon="Yes",
                     WitnessYear=2012,EyeWitness="Yes")

pred1<-predict(fit,newdata1,type="class")
pred1<-droplevels(pred1)  #Kidnapping
actual1<-as.factor(c("Murder"))
confusionMatrix(pred1,actual1,mode="everything")

newdata2<-data.frame(RegisteredYear=2014,RegisteredMonth=10,RegisteredDate=23,ActualYear=2014,
                     SolvedYear=2014,CaseCountry="India",CaseState="Haryana",CaseCity="Manorgarh",
                     CriminalStatus="Arrested",SuspectGender="Male",SuspectDominantHand="Right",
                     SuspectRelationshipWithVictim="None",SuspectCountry="India",
                     SuspectState="Haryana",SuspectCity="Manorgarh",SuspectOccupation="Owner",
                     VictimGender="Female",VictimMaritialStatus="Married",VictimMotherStatus="Not Known",
                     VictimFatherStatus="Not Known",VictimCountry="India",VictimState="Haryana",
                     VictimCity="Manorgarh",VictimOccupation="Housewife",complaintYear=2011,complaintAge=34,
                     Movite="Depression",ComplaintGender="Male",ComplaintDominantand="Right",
                     ComplaintOccupation="Owner",EvidenceType="Body",PoliceCountry="India",
                     PoliceState="Haryana",PoliceCity="Manorgarh",WeaponType="Ax",MainWeapon="Yes",
                     WitnessYear=2012,EyeWitness="Yes")

pred2<-predict(fit,newdata2,type="class")
pred2<-droplevels(pred2)  #Murder
actual2<-as.factor(c("Robbery"))
confusionMatrix(pred2,actual2,mode="everything")
