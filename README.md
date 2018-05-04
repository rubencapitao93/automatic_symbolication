## Usage ##

1. In your MacBook, create a new folder to store all the necessary resources. The resources are:
  1. The _symbolicate.sh_ script;
  2. The crash log file with the stack of the error;
  3. The _.app.dSYM_ file (is actually a compressed folder...) from the source code of the application installed on the device.
2.Open a terminal in the folder created in step 2, and run the following commands:
  1. To be able to execute the script:
  `chmod u+x symbolicate.sh`
  
  2. To perform the symbolication of a crash file with the output to console:
  `./symbolicate.sh <appName>.app.dSYM/Contents/Resources/DWARF/<appName> <crash_file>`
  
  where <appName> is the name of the mobile application and <crash_file> is the file containing the error stack.
  Alternatively, you can send the output to a file using the below command:
  `./symbolicate.sh <appName>.app.dSYM/Contents/Resources/DWARF/<appName> <crash_file> > <output_file>`

After that, you'll visualize useful information for troubleshooting instead of random memory addresses (as depicted below).
