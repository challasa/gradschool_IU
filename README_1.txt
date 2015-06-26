googlesearch.py
---------------
This program takes in search term from user, performs google search and fetches the titles and URL of the first result from the search.

To run this program the following Python module must be available. On Windows it should be in Python\Lib\site-packages folder. If not available, please install it.
simplejson:
Here is the URL to the simplejson project page.
http://code.google.com/p/simplejson/
For Windows 32 bit, there is an executable file available here:
http://pypi.python.org/pypi/simplejson
If on Mac, please look up here:
http://www.turbogears.org/download/filelist.html

If this program is run on Windows 32 bit system, there is a  simplejson.exe file along in this folder. Please use that.


To run from command line in Unix or Windows:

python googlesearch.py

-------------------------------------------------------------
Implementation:

Since google search is a RESTful service, I looked for the particular URL to use to call the service. By searching online on Stackoverflow and google I got the Google AJAX API URL. The output of that service is in JSON format and simplejson module in Python helps to parse the JSON. 

These are the links I looked online. One of the websites has the exact implementation asked for. 
http://broadcast.oreilly.com/2009/04/brand-research-with-google-sea.html
http://stackoverflow.com/questions/2799702/python-using-google-ajax-search-apis-local-search-objects
http://developer.yahoo.com/python/