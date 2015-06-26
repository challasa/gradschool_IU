#The following program takes in the users input search term, performs search on the web
#using google search engine and fetches the Title and URL of the first result obtained.

import urllib
import urllib2
import simplejson
import sys

#function to perform google search
def googlesearch(search_term):
    #Encode the search term.
    query_string = urllib.urlencode({'q' : search_term.rstrip("\n")})

    #This is the URL used to query google. (REST service based on Google Search Ajax API)
    googleREST_URL = "http://ajax.googleapis.com/ajax/services/search/web?v=1.0&%s" % (query_string)

    #Perform Google search on the given term
    search_results = urllib2.urlopen(googleREST_URL)

    #Load the results of the search into a JSON Array
    results_json = simplejson.loads(search_results.read())

    #print results_json
    results = results_json['responseData']['results']

    for result in results[:1]:
        title = result['title']
        url = result['url']

    return (title,url)
    #print "%s\nTitle:%s\nURL:%s" % (search_term.rstrip("\n"), title, url)

#Take in Users search term
searchterm = raw_input("Enter the search term \n")
print "Search Term you entered is:", searchterm

required_output = googlesearch(searchterm)

print "Title:", required_output[0]
print "URL:", required_output[1]



