#!/usr/bin/python 

""" 
This is a Python program to extract dialog from TEI XML documents, like the Shakespeare TEI files available at the MONK project, provided that the dialog is marked up with the speakers' names in the format <sp who="speaker"> with the dialog in child <l> tags. 

Run this program with the command: 
	python parse.py your-xml-file-here.xml
Or optionally: 
	python parse.py -c list-of-characters.txt your-xml-file-here.xml

If you don't provide a list of characters whose dialog to extract, this program will look for characters.txt in the current working directory. 

The characters.txt file should contain a comma-separated list of character xml IDs for all the characters whose dialog you want to extract. For example: 
	Hamlet,aww-stew.,aww-clo.,Reynaldo

This has only been tested with TEI XML Shakespeare plays. 

"""
import sys # library for doing system things 
from optparse import OptionParser #parse options from the command line!
from lxml import etree # for parsing XML
import re # need regex for doing fancy split

usage = 'usage: %prog [options] file1.xml [file2.xml]'
parser = OptionParser(usage)
parser.add_option("-c", "--characters", action="store", dest="characters",         
		help="A text file containing a comma-separated list of the names (i.e. XML IDs) of the characters whose dialog you want to extract. Default: characters.txt")
parser.add_option("-v", "--verbose",
            action="store_true", dest="verbose")
parser.add_option("-q", "--quiet",
            action="store_false", dest="verbose")

#Error check TEI files
(options, args) = parser.parse_args()
if len(args) < 1:
    parser.error("Please specify at least one XML file.")

if not options.characters: 
	charactersFile='characters.txt'
else: 
	charactersFile=options.characters

#Error check Characters file
try: 
	rawCharacters=open(charactersFile).read()
except IOError: 
	parser.error("Can't find characters file. Do you have a characters.txt in this directory, or did you specify its location in an option?") 

#Parse characters file
charactersMessy=re.split('\n|,',rawCharacters) #split by commas or newlines and strip out whitespace
characters=[]
for character in charactersMessy: 
	characters.append(character.strip()) #remove whitespace
characters=filter(None,characters) # get rid of empty characters

#Verbose output will help to debug
if options.verbose:
        print "Using these characters: "
        for character in characters:
                print '  '+character
        print "Using these files: "
        for index, value in enumerate(args): 
                print ' ',index+1, value

#load xml files
xmls=[etree.parse(file) for file in args] #open and parse files and store them in a list

if options.verbose: 
	print "Files loaded successfully." 

#Sample Files and Characters
#xmlfile='ham.xml' #example file for now
#characters=['Barnardo','Francisco','Othello']
#xml=etree.parse(xmlfile)

#from suggestion here: http://stackoverflow.com/questions/16640041/what-is-an-elementtree-object-exactly-and-how-can-i-get-data-from-it?noredirect=1#16640278 
nsmap = {'s': 'http://www.tei-c.org/ns/1.0'}

output=[]
for xml in xmls: 
 	for character in characters: 
		output+=xml.xpath('.//s:sp[@who="'+character+'"]/s:l/text()', namespaces=nsmap)

clean=""
#new way 
clean = '\n'.join(line.strip() for line in output)
#old way
#for line in output: 
#	clean+=line.strip()+'\n' #strip all extra space and then make them individual lines

#encoding it makes it work with piping as described here: http://stackoverflow.com/questions/492483/setting-the-correct-encoding-when-piping-stdout-in-python 
encoded=
sys.stdout.write(clean.encode('utf-8'))
