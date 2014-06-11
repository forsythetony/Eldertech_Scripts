### Status 
|Date Tested   |Status       |Description|
|:-------------|-------------|:---------:|
|Unknown       |**Unknown**|Needs testing|

### Purpose

To automate as much of the process of setting up hospital computers as possible. 

This script will do the following:
* Edit files in the Kinect folder specifically...
   * Edit the config.txt file to account for new computer name
   * Change the shorcut to account for new computer name
   * Edit mountElektro.bat file to account for new computer name
* Update the computer's date and time
* Rename Kinect shortcut in start menu to account for new computer name
* Unmount and remount the z: drive using the recently updated mountElektro.bat file

### How to Use

1. Run the script (Refer to wiki for basic guides on running scripts in Powershell)
2. When prompted enter the following and hit enter after each entry:
   1. The five digit old computer number (This is the number the script will use when searching for files)
   2. Enter the two digit new prefix (In most cases this will be '10')
   3. Enter the three digit new computer number
   4. Enter the date in the specified format
   5. Enter the time in the specified format
3. The script should now run and complete in a matter of seconds.

### Contact Info

If I didn't write this script forever ago relative to your current time, feel free to contact me with questions.
* Name: Anthony Forsythe
* School Email: arfv2b@mail.missouri.edu
* Other Email: forsythetony@gmail.com
