import sys # library for parsing command line parametrs
from lxml import etree # for parsing XML

filenames=[filename for filename in sys.argv[1:]] #store filenames
print "Using files: " #Display filenames
for filename in filenames:
	print filename
xmls=[etree.parse(file) for file in sys.argv[1:]] #open and parse files
print 'Files loaded successfully.'  

#xmlfile='ham.xml' #example file for now
characters=['Barnardo','Francisco']
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

