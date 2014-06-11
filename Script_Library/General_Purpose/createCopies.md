### Purpose

Using the contents of a folder titled 'original' within a directory, this script will create 10 more copies of that folder for testing purposes.

### How to Use

1. Before starting the script...
   1. In the setData function, edit $folderPath so that it points to the directory containing the 'original' folder.
   2. Optionally change $newFolderName to the base name for the copied folders. 
   3. $originalName should be the name of the folder with the contents to be copied, followed by a backslash and asterisk. Ex. "originalFolder\\\*"
   4. Change $foldersToCreate to the number of copies you wish to create
2. Once all the proper variables are set you can run the script. Depending on the size of the original folder and the number of copies being created, the process may take some time.
