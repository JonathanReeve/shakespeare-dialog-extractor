#About
This program accepts a list of characters and outputs those characters' dialog to standard output. This was designed to extract dialog from Shakespeare plays marked up in TEI XML, but could be adapted for other authors. Unless a character list filename is specified by the `-c` option, it looks for a file in the current working directory called `characters.txt`. It can accept any number of XML files, so you can run it on, say, all of Shakespeare's plays at once, using your operating system's wildcard (\*). 

#Usage
From the command-line, run: 

    python parse.py [-c characters.txt] file1.xml [file2.xml] 

#Examples
To get all of Ophelia's speech from the play Hamlet, and store the dialog in a file called `opelia-dialog.txt`, run: 
    
    echo "Ophelia" > characters.txt
    python parse.py ham.xml > ophelia-dialog.txt

To get all the dialog from all of Shakespeare's fools, and store it in a file called `fools-dialog.txt`, first make sure your directory contains [XML files for all of Shakespeare's plays](http://www.monkproject.org/downloads/texts/sha.gz), then run: 
    echo "Touchstone,kil-fool.,Trinculo,Costard,Feste,Launcelot,aww-clo.,tim-fool.,Bottom,Thersites,oth-clo.,DromioS,DromioE,Speed,Launce,ham-sec.-clo.,ham-first-clo.,juc-cit1.,juc-cit2.,juc-cit3.,juc-cit4.,juc-cits.,PompeyBum,win-clo.,Grumio,mac-porter.,mac-port.,Peter1,Cloten,Falstaff1" > characters.txt
    python parse.py *.xml > fools-dialog.txt

#Characters.txt
Your characters.txt file should contain a comma-separated list of the XML IDs for all the characters whose dialog you want to extract. See example files in this directory.  

#Contents of this Directory
 * parse.py: The python script that extracts the dialog. 
 * characters.txt: This is just a sample characters.txt file showing the ways you can list the characters whose dialog you want to extract. Use the XML IDs for character names. 
 * ham.xml, mac.xml, oth.xml: Sample TEI XML Shakespeare plays. 
 * /character-lists: This directory contains sample character list files. 
 
#License 
This software is released under the GPLv3. 
