

dirV=getDirectory("Where are the frames?");
listV = getFileList(dirV);

//file naming
ll=listV.length;
//print(ll);
vfn=newArray(0);
vcs=newArray(0);

for(i=0;i<ll;i++){
	nev=split(listV[i],"~");
	vfn=Array.concat(vfn,nev[0]);
	csat=split(nev[1],".");
	vcs=Array.concat(vcs,csat[0]);
}

//Array.show(vfn);

dirR=getDirectory("Where are the ROIs?");
listR = getFileList(dirR);
ll2=listR.length;
//roi filename
rfn=newArray(ll2);
//roi nucleus name
rmn=newArray(ll2);

for(i=0;i<ll2;i++){
	nev=split(listR[i],".");
	nev2=split(nev[0],"+");
	if (nev2.length>1){
		rfn[i]=nev2[0];
		rmn[i]=nev2[1];
	}
}
//Array.show(listV,listR,vfn,vcs,rfn,rmn);
//Array.show(listV,listR);

 roiManager("reset");
 setBackgroundColor(0, 0, 0);

setResult("Slide",0,vfn[0]);
setResult("Channel",0,vcs[0]);
setResult("Nucleus",0,rmn[0]);
setResult("Axon length",0,"0");
IJ.renameResults("Results","Summary");

sz=0;
 
for(k=0;k<ll;k++){
	open(dirV+listV[k]);

	
	idk=getImageID();
	for(r=0;r<ll2;r++){
		if (vfn[k]==rfn[r]){
			roiManager("Open", dirR+listR[r]);
			print(k, r, dirV+listV[k], dirR+listR[r]);
			
			selectImage(idk);
			run("Duplicate...", "title="+rfn[r]+"+"+rmn[r]+" duplicate");
			idm=getImageID();
			
			roiManager("select",0);
			run("Clear Outside", "stack");
			run("Select None");
			run("Analyze Skeleton (2D/3D)", "prune=[shortest branch] prune show");
			selectWindow("Results");
			run("Close");
			IJ.renameResults("Branch information","Results");
			
			hossz=0;
			for(res=0;res<nResults();res++){
				hossz=hossz+getResult("Branch length",res);
			}
			selectWindow("Results");
			run("Close");
			IJ.renameResults("Summary","Results");
			setResult("Slide",sz,vfn[k]);
			setResult("Channel",sz,vcs[k]);
			setResult("Nucleus",sz,rmn[r]);
			setResult("Axon length",sz,hossz);
			IJ.renameResults("Results","Summary");
			sz=sz+1;

 			if (isOpen(idm)==1){
				selectImage(idm);
				close();
 			}
		}
		roiManager("reset");
		
	}
	if (isOpen(idk)==1){
		selectImage(idk);
		close();
	}
}
