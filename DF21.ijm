// yz566
//Please ask for access 
//For superres
//Please install the required plugins and put the fiji path here
fjpath="C://Users//zhang//Downloads//fiji-win64//Fiji.app//";

run("Clear Results");
requires("1.33s"); 
   dir = getDirectory("Choose a Directory");
   count = 0;
   countFiles(dir);
   n = 0;
  setBatchMode(true);
   processFiles(dir);
   
   function countFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
  if (!startsWith(list[i],"Log")){
        if (endsWith(list[i], "/"))
              countFiles(""+dir+list[i]);
          else
              count++;
      }
  }
}
   function processFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
if (!startsWith(list[i],"Log")){
          if (endsWith(list[i], "/"))
              processFiles(""+dir+list[i]);
          else {
             showProgress(n++, count);
             path = dir+list[i];
             processFile(path);
          }
}
      }
  }

  function processFile(path) {
       if (endsWith(path, ".tif") || endsWith(path, ".tiff") || startsWith(path, "X")) 
       {
		open(path);

		File.makeDirectory(path+"P\\");
		path2=path+"P\\";

		fpath= path;
        fpath2= path2;
       
        svpath1=path2+"raw.jpg";
        svpath2=path2+"Results.txt";
        svpath3=path2+"Branch information.csv";
        svpath4=path2+"points.jpg";
        svpath4x=path2+"loclist.csv";
     
		file= getTitle();				// image filename.tif 
		root = substring(file,0,indexOf(file, ".tif"));		// image rootname
		setBatchMode(false);
        filename=file;

		avgfile="AVG_"+filename;
        namfile=filename;
        path1x=fjpath+"loclist.csv";
		
        open(fpath);
        selectWindow(namfile);
        run("Z Project...", "start=10 projection=[Average Intensity]");
        selectWindow(namfile);
        close();
        selectWindow(avgfile);
        run("Enhance Contrast", "saturated=0.35");
        saveAs("Jpeg", svpath1);
        run("Run analysis", "filter=[Wavelet filter (B-Spline)] scale=2.0 order=3 detector=[Centroid of connected components] watershed=false threshold=0.5*std(Wave.F1)+0.1*mean(Med.F) estimator=[PSF: Integrated Gaussian] sigma=1.6 fitradius=5 method=[Maximum likelihood] full_image_fitting=false mfaenabled=false renderer=[Scatter plot] dxforce=false magnification=10.0 dx=10.0 colorizez=false threed=false dzforce=false repaint=50");
        File.copy(path1x, svpath4x);
        selectWindow("Scatter plot");
        run("Find Maxima...", "prominence=0 output=List");
        saveAs("Results", svpath2);
        close();
        selectWindow(avgfile);
        saveAs("Jpeg", svpath4);
        close("*");
     
} 	// End If loop	
}	// End batch processing loop

print("All done");
