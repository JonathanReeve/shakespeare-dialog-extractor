from lxml import etree

xmlfile='ham.xml' #example file for now
characters=['Barnardo','Francisco']
xml=etree.parse(xmlfile)

#from suggestion here: http://stackoverflow.com/questions/16640041/what-is-an-elementtree-object-exactly-and-how-can-i-get-data-from-it?noredirect=1#16640278 
nsmap = {'s': 'http://www.tei-c.org/ns/1.0'}

output=[]
for character in characters: 
	output+=xml.xpath('.//s:sp[@who="'+character+'"]/s:l/text()', namespaces=nsmap)

print(output) 

