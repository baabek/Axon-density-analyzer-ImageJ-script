
time1=getTime();

thr0=0.8;

dir=getDirectory("Where are the kernels?");
kerlist = getFileList(dir);

dir1 = getDirectory("Save frames to...");


getDimensions(w, h, ch, sl, fr);
nev0=getTitle();
id0=getImageID();
nA=split(nev0,".");
nev1=nA[0];

szinek=newArray(ch);

for (c=1;c<ch+1;c++){
	setSlice(c);
	
	getLut(r,g,b);

	Array.getStatistics(r,rmin,rmax);
	Array.getStatistics(g,gmin,gmax);
	Array.getStatistics(b,bmin,bmax);
	if(rmax>0 && gmax==0 && bmax==0){
		szinek[c-1]="red";
	}
	if(rmax==0 && gmax>0 && bmax==0){
		szinek[c-1]="green";
	}
	if(rmax==0 && gmax==0 && bmax>0){
		szinek[c-1]="blue";
	}
	if(rmax>0 && gmax>0 && bmax==0){
		szinek[c-1]="yellow";
	}
	if(rmax>0 && gmax==0 && bmax>0){
		szinek[c-1]="magenta";
	}
	if(rmax==0 && gmax>0 && bmax>0){
		szinek[c-1]="cyane";
	} 	
	if (rmax>0 && gmax>0 &&bmax>0){
		szinek[c-1]="gray";
	}

	
}
setSlice(1);



Dialog.create("Channels");
for (c=0;c<ch;c++){
  Dialog.addString("   Ch"+c+1+":          ", szinek[c]);
  Dialog.addCheckbox(" ", true);
  Dialog.addNumber("Thr for Ch"+c+1+":", thr0);
  Dialog.addChoice("Type:", kerlist);
  Dialog.addMessage("\n \n");
}
  Dialog.show();
  //channel name
csN=newArray(ch);
//need?
kell=newArray(ch);
//list of thresholds
th=newArray(ch);
//list of kernels
ke=newArray(ch);

for (c=0;c<ch;c++){
   csN[c] = Dialog.getString();
   kell[c]=Dialog.getCheckbox();
   th[c]=Dialog.getNumber();
   ker=Dialog.getChoice();
   ker2=substring(ker,0,lengthOf(ker)-1);
   ke[c]=dir+ker2+"\\";
}


Array.show(csN, kell, th, ke);


setBatchMode(true);


for (c=0;c<ch;c++){
	if (kell[c]==1){
	
	ujnev=nev1+"~"+csN[c];

	
	kerlist=getFileList(ke[c]);
	nk=kerlist.length;
	
	
	selectImage(id0);
	cx=c+1;
	run("Duplicate...", "title=Ch_"+cx+" duplicate channels="+cx);
	id0c=getImageID();
	waitForUser("SO?", "Is this the right image?");
	
	newImage(ujnev, "8-bit black", w, h, sl);
	idv=getImageID();

	for (sik=1;sik<sl+1;sik++){

		newImage("vonal", "8-bit black", w, h, nk);
		id1=getImageID();
		
		for (i=0;i<nk;i++){
			
			selectImage(id0c);
			setSlice(sik);
			run("Duplicate...", "title=mas");
			idm=getImageID();
			run("8-bit");
			
			print(ke[c]+kerlist[i]);
			run("Convolve...", "text1=["+File.openAsString(ke[c]+kerlist[i])+"] normalize");
			selectImage(idm);
		
			
			
			getStatistics(vilarea, vilmean, vilmin, vilmax);
			
			thrmin=vilmax-(vilmax-vilmin)*th[c];

					run("Threshold...");  // open Threshold tool
					  setAutoThreshold("Default dark");
					  setThreshold(thrmin, vilmax);
					  setOption("BlackBackground", false);
					  run("Convert to Mask", "stack");
					  selectWindow("Threshold");
					  run("Close");
		
		
			
					  
			selectImage(idm);
			run("Despeckle");
			run("Select All");
			run("Copy");
			run("Close");
			selectImage(id1);
			setSlice(i+1);
			run("Paste");
			
		} 
		selectImage(id1);
		run("Skeletonize (2D/3D)");
		run("Z Project...", "projection=[Max Intensity]");
		id2=getImageID();
		run("Select All");
		run("Copy");
		
		selectImage(idv);
		setSlice(sik);
		run("Paste");
		selectImage(id1);
		run("Close");
		selectImage(id2);
		run("Close");
		
		
		
	} 
	selectImage(id0c);
	run("Close");
	selectImage(idv);

	
	getDimensions(iW, iH, iCh, iSl, iFr);
	makeRectangle(1,1,iW-3,iH-3);
	
	run("Erode", "stack");
	run("Select None");
	run("Skeletonize (2D/3D)");





	saveAs("Tiff", dir1+ujnev+".tif");
	run("Close");
	}
}


time2=getTime();
dt=time2-time1;
h=floor(dt/(60*60*1000));
hmar=dt-h*60*60*1000;
m=floor(hmar/(60*1000));
mmar=hmar-m*60*1000;
sec=floor(mmar/1000);
ms=mmar-sec*1000;

setBatchMode(false);

print("It took: " + h + "h:" + m + "m:" + sec + "s:" + ms + "ms");
