# Content Performance Chart
A small app to visualise the percentage of content people read from each page on [pensionwise.gov.uk]
against the number of unique pageviews that each page received during a day. Analyses the govspeak 
content from the [content directory] of the [pension guidance repository] and combines it with data 
from Google Analytics to produce this [Content Performance Chart].

The main idea is that:

<tt>If someone spent 60 seconds reading a page and the content on that page takes 300 seconds to read, s/he would have read 20%</tt>

All aggregated data are kept in [Pension Wise Content] table as a shared [Google Fusion Table] 
so that product and business analysts can access it without the need to involve developers.

## Percentage of Content Read
How much of the content would one read if they allocated their entire page-visit to reading.

<tt>Average Time On Page / Expected Reading Time</tt>

### Expected Reading Time
How long would it take someone to read the entire content on the page.

The number of examples that appear on the page add to the total reading time since they incur extra cognitive load.

<tt>Number of Words / Words Per Second + Number of Examples * 7 seconds</tt>

<tt>Words Per Second = 200 Words Per Minute / 60</tt>

Jakob Nielsen of the Norman Nielsen group uses 200 words per minute (WPM) in [How little do users read?]

### Average Time On Page
Average amount of time users spent viewing a page as defined in 
[Google Analytics Core API](https://developers.google.com/analytics/devguides/reporting/core/dimsmets#view=detail&group=page_tracking&jump=ga_avgtimeonpage)

Preferred over [time on page](https://developers.google.com/analytics/devguides/reporting/core/dimsmets#view=detail&group=page_tracking&jump=ga_timeonpage) 
which does not apply to exit pages.

## Unique Pageviews
The number of different (unique) pages within a session as defined in 
[Google Analytics Core Reporting API](https://developers.google.com/analytics/devguides/reporting/core/dimsmets#view=detail&group=page_tracking&jump=ga_uniquepageviews)

A session according to [how visits are calculated in Google Analytics](https://support.google.com/analytics/answer/2731565)
expires after 30 minutes of inactivity or at midnight.

# Interpretation
## Top Left Quarter: Challenge
_Enough people_ visit that page but _read less than 50%_ of its content:

- Poor readability score? Would simplifying the language make it better?
- Length of content? Would splitting the content into multiple pages make people read it?
- Too many internal links? Do people jump to a different page without reading?
- Too many external links? Do people jump to an external site?
- Too many examples? Too many examples on that page which increase the expected reading time?
- Does the page also have high exit rates?

## Top Right Quarter: Great
_Enough people_ visit that page and do _read more than 50%_ of its content:

- This is where all of the core content should end up

## Bottom Right Quarter: Good
People who visit that page _read more than 50%_ of its content but _not enough people_ visit it:

- It it a page of special interest that justifies this, e.g. about divorce?
- Should this page be made more prominent by linking to it more often?
- Should online marketing be targeting this page to increase its traffic?

## Bottom Left Quarter: Bad
_Not enough people_ visit that page and those who do _read less than 50%_ of its content:

- The worst place to be..
- Improve the percentage of content read on that page before trying to increase its traffic

## Limitations

The homepage is excluded from the Content Performance chart as it warrants special analysis.

Expected Reading Time does not take into account:

- Page elements such as headers, footers, images, and side content that incur cognitive load on a user and hence require extra time to process
- Reading score as a factor of content complexity that could impact reading time
- Repeat visits to the same page during a single session

# Usage
Collect data:

```ruby
rake collect
```

Start the app:

```sh
$ ./bin/foreman s
```

# Google Developers Console
[Pension Wise Google Developers Console]

# Dependencies
* [Sinatra]
* [Lingua]
* [Govspeak Markdown Extension]
* [Google Fusion Tables API]
* [Google Analytics Reporting API]
* [D3 Data-Driven Documents]

# Useful Links
- [How long do users stay on web pages?] _Jakob Nielsen, Nielsen Norman Group, 12/09/2011_
- [How little do users read?] _Jakob Nielsen, Nielsen Norman Group, 06/05/2008_
- [How users read on the web] _Jakob Nielsen, Nielsen Norman Group, 01/09/1997_
- [Introducing the Content Explorer] _Edward Horsford, GDS, 01/03/2013_
- [Flesch-Kincaid readability tests] _Wikipedia_
- [Delightful UX: Medium's time to read]
- [Medium: Read time and you]
- [Medium: The only metric that matters - Total Reading Time]
- [Medium: This should only take a minute or four, probably]

[pensionwise.gov.uk]: https://www.pensionwise.gov.uk
[content directory]: https://github.com/guidance-guarantee-programme/pension_guidance/tree/master/content
[pension guidance repository]: https://github.com/guidance-guarantee-programme/pension_guidance
[Content Performance chart]: http://ggp-content-performance.herokuapp.com
[Pension Wise Content]: https://www.google.com/fusiontables/DataSource?docid=1QUbEiGVnM6NWOJ62ciDwQMkUjTI0XjMZJg4FAJTo
[Pension Wise Google Developers Console]: https://console.developers.google.com/project/pension-wise
[Sinatra]: http://www.sinatrarb.com
[Lingua]: https://rubygems.org/gems/lingua
[Govspeak Markdown Extension]: https://github.com/alphagov/govspeak
[Google Fusion Table]: http://tables.googlelabs.com
[Google Fusion Tables API]: https://developers.google.com/fusiontables
[Google Analytics Reporting API]: https://developers.google.com/analytics/devguides/reporting
[D3 Data-Driven Documents]: http://d3js.org

[How long do users stay on web pages?]: http://www.nngroup.com/articles/how-long-do-users-stay-on-web-pages
[How little do users read?]: http://www.nngroup.com/articles/how-little-do-users-read
[How users read on the web]: http://www.nngroup.com/articles/how-users-read-on-the-web
[Introducing the Content Explorer]: https://gds.blog.gov.uk/2013/03/01/introducing-content-explorer
[Flesch-Kincaid readability tests]: http://en.wikipedia.org/wiki/Flesch–Kincaid_readability_tests
[Delightful UX: Medium's time to read]: http://www.mdswanson.com/blog/2013/07/04/delightful-ux-mediums-time-to-read.html
[Medium: Read time and you]: https://medium.com/the-story/read-time-and-you-bc2048ab620c
[Medium: The only metric that matters - Total Reading Time]: https://medium.com/data-lab/mediums-metric-that-matters-total-time-reading-86c4970837d5
[Medium: This should only take a minute or four, probably]: https://medium.com/@fchimero/this-should-only-take-a-minute-or-four-probably-e38bb7bf2adf
