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

# copy URL of page to be scraped and read HTML with read_html(url)
# returns an xml_document object for manipulation with rvest functions
read_html("https://rvest.tidyverse.org/")

# write inline HTML with minimal_html()
html_min <- minimal_html("
<p>This is a paragraph</p>
<ul>
  <li>This is a bulleted list</li>
</ul>
")
html_min

# use CSS selectors to identify elements of interest and extract data
# selectors define patterns for locating HTML elements
# p selects all <p> elements
# .title selects all elements with class 'title'
# #title selects element with id 'title', id is always unique

html_ex <- minimal_html("
  <h1>This is a heading</h1>
  <p id='first'>This is a paragraph</p>
  <p class='important'>This is an important paragraph</p>
")

# use html_elements() to find elements that match selector
html_ex |> html_elements("p")
html_ex |> html_elements(".important")
html_ex |> html_elements("#first")

# html_element() (no s) returns the same number of outputs as inputs
# returns first match when applied to an entire document
html_ex |> html_element("p")

# when using a selector that does not match any elements, 
# html_elements() returns a vector of length 0
# html_element() returns a missing value
html_ex |> html_elements("b")
html_ex |> html_element("b")

# both are typically used together
# html_elements() finds elements that will become observations
# html_element() then finds elements that will become variables

# unordered list of 4 items
html_ul <- minimal_html("
  <ul>
    <li><b>C-3PO</b> is a <i>droid</i> that weighs <span class='weight'>167 kg</span></li>
    <li><b>R4-P17</b> is a <i>droid</i></li>
    <li><b>R2-D2</b> is a <i>droid</i> that weighs <span class='weight'>96 kg</span></li>
    <li><b>Yoda</b> weighs <span class='weight'>66 kg</span></li>
  </ul>
")

# create vector of characters using html_elements()
characters <- html_ul |> html_elements("li")
characters

# extract name of characters by applying html_element() to output
characters |> html_element("b")

# when applied to a vector, html_element() maintains
# connection between inputs and outputs
characters |> html_element(".weight")

# html_elements() returns all matches so connection is lost
# if not all inputs have a corresponding output
characters |> html_elements(".weight")

# once elements are selected, need to extract data from contents or attributes

# html_text2() extracts plaintext contents of HTML element
# html_text2() is recommended over html_text()
characters |> 
  html_elements("b") |> 
  html_text2()

characters |> 
  html_elements(".weight") |> 
  html_text2()

# escapes are handled within rvest, present in source HTML but not in output

# html_attr() extracts data from attributes
# always returns a string, so numbers and dates will require post-processing
html_hrefs <- minimal_html("
  <p><a href='https://en.wikipedia.org/wiki/Cat'>cats</a></p>
  <p><a href='https://en.wikipedia.org/wiki/Dog'>dogs</a></p>
")

html_hrefs |> 
  html_elements("p") |> 
  html_elements("a") |> 
  html_attr("href")

# data can be read from an HTML table if already stored in one
# HTML tables contain <table> <tr> <th> <td> tags
html_table <- minimal_html("
  <table class='mytable'>
    <tr><th>x</th>   <th>y</th></tr>
    <tr><td>1.5</td> <td>2.7</td></tr>
    <tr><td>4.9</td> <td>1.3</td></tr>
    <tr><td>7.2</td> <td>8.1</td></tr>
  </table>
")

# html_table() returns a list containing one tibble for each table
# on an HTML page, so it can be combined with html_element()
# to extract just one specific table from the page
html_table |> 
  html_element(".mytable") |> 
  html_table()
