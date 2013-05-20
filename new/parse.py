import sys # library for parsing command line parametrs
from optparse import OptionParser #parse options from the command line!
from lxml import etree # for parsing XML

#filenames=[filename for filename in sys.argv[1:]] #store filenames
#print "Using files: " #Display filenames
#for filename in filenames:
#	print filename
#xmls=[etree.parse(file) for file in sys.argv[1:]] #open and parse files
#print 'Files loaded successfully.'  

usage = 'usage: %prog -c  character1,character2  [options] file1.xml [file2.xml]'
parser = OptionParser(usage)
parser.add_option("-c", "--characters", action="store", dest="characters",         
            help="Names (XML IDs) of the characters whose dialog you want to extract.")
parser.add_option("-v", "--verbose",
            action="store_true", dest="verbose")
parser.add_option("-q", "--quiet",
            action="store_false", dest="verbose")

(options, args) = parser.parse_args()
if len(args) != 1:
    parser.error("Please specify a TEI filename.")

characters=options.characters.split(',') #split up character names from input

#Verbose output 
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
for line in output: 
	clean+=line.strip()+'\n' #strip all extra space and then make them individual lines

print(clean) 

