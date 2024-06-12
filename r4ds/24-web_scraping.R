{
  library("tidyverse")
  library("rvest")
}

# some websites provide a web API for obtaining data in JSON format
# not all websites provide an API, one way to gather data is by web scraping
# use web API whenever possible as it provides more reliable data

# must consider ethics and legalities of scraping before doing so
# contact a lawyer if data is not public, non-personal, or factual
# or intent is to make money off data analysis

# be considerate of server resources when scraping
# use polite package to automatically space out requests and cache results

# websites may have terms and conditions or terms of service page
# that prohibits web scraping, may be bound by them depending on country

# be careful when scraping personally identifiable information
# names, dates of birth, email addresses, phone numbers
# General Data Protection Regulation (GDPR) in Europe has strict laws
# regarding how personal data can be collected and stored

# copyright law is complicated but also can also affect legality of scraping
# databases may have property rights that protect against scraping
# fair use may offer some protection but does not always apply

# web pages are built using HTML, HyperText Markup Language
# hierarchically structured elements containing a start tag, usually an end tag,
# optional attributes, and contents between start and end tag

# &gt; escapes >, &lt; escapes <, &amp; escapes &

# most pages have a consistent structure, allowing web scraping to work
# every HTML page must be within <html> element which contains two children,
# <head> containing document metadata and <body> for contents visible in browser
# block tags form overall page structure, e.g. <h1> <section> <p> <ol>
# inline tags format text inside block tags, e.g. <b> <i> <a>

# MDN web docs provides info on other HTML tags not listed
# https://developer.mozilla.org/en-US/docs/Web/HTML

# elements may contain text or other elements between start and end tags
# children are elements contained within, may have contents but no children

# tags may have named attributes with corresponding values
# e.g. name1='val1' name2='val2'
# id and class attributes are used with Cascading Style Sheets (CSS)
# to control appearance of specific elements on page, also useful for scraping
# href attribute in <a> identifies destination of link
# src attribute in <img> identifies source of image