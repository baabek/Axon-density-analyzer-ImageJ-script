
dir1 = getDirectory("Where are the original images");
list1 = getFileList(dir1);

dir3= getDirectory("Save ROIs to...");


tovkep=1;
kepnev=newArray(0);
magnev=newArray(0);
magterulet=newArray(0);


i=0;
 showProgress(i+1, list1.length);
 
	while (tovkep>0){
		print(list1[i]);
		open(dir1+list1[i]);
		setLocation(30, 100);
		ida=getImageID();
		nevNull=getTitle();
		p1=split(nevNull,".");
		nev1=p1[0];

		setTool("polygon");
		van=1;
		while (van>0){
			if (roiManager("count")>0){
				roiManager("Delete");
			}
			
			title = "Untitled";
			Dialog.create("Name the next nucleus");
			  Dialog.addString("Nucleus name:", title);
			  Dialog.show();
			  mag = Dialog.getString();
			  
			  
			  kepnev=Array.concat(kepnev,nev1);
			  magnev=Array.concat(magnev, mag);
			  
			
			title = "Choose nucleus";
			  msg = "Draw "+mag+" nucleus in the image, then press \"OK\".";
			  waitForUser(title, msg);
			  run("Add to Manager");

			roiManager("Save", dir3+nev1+"+"+mag+".zip");
	
	
			if (roiManager("count")>0){
				roiManager("Delete");
			}
			
			
			
			van=getBoolean("Do you want to draw another nucleus?");
			
		} 
		selectImage(ida);
		run("Close");

		tovkep=getBoolean("Do you want another image?");
		
		if (i<list1.length-1){
			i=i+1;
		} else {
			tovkep=0;
		}

		
	}