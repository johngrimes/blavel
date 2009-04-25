module ApplicationHelper  
  
  # Sets content type of response to UTF8 XML.
  def set_utf_xml
    headers['Content-Type'] = 'text/xml; charset=UTF-8'
  end
  
  # Sets content type of response to UTF8 JSON.
  def set_utf_json
    headers['Content-Type'] = 'application/json; charset=UTF-8'
  end
  
  # Sets content type of response to UTF8 RSS.
  def set_utf_rss
    headers['Content-Type'] = 'application/rss+xml; charset=UTF-8'
  end
  
  # Outputs a set of customised pagination links
  def paginate_links(records)
    links = will_paginate(records)
    if links.blank?
      return links
    else
      return links.gsub('Previous', 'previous').gsub('Next', 'next')
    end
  end
  
  # Formats a date for display.
  def pretty_date(date)
    "#{date.strftime('%B')} #{date.day}, #{date.year}"
  end
  
  # Formats a date to be RFC822 compliant (used in RSS).
  def rfc822_date(date)
    date.strftime("%a, %d %b %Y %H:%M:%S GMT")
  end
  
  # Formats a date to be W3C compliant (used in Sitemaps.org format).
  def w3c_date(date)
    date.strftime("%Y-%m-%dT%H:%M:%SZ")
  end
  
  # Outputs the necessary scripts to enable Google Analytics on a page.
  def analytics_tag
    "<script type=\"text/javascript\">
    <!--
            var gaJsHost = ((\"https:\" == document.location.protocol) ? \"https://ssl.\" : \"http://www.\");
            document.write(unescape(\"%3Cscript src='\" + gaJsHost + \"google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E\"));
    //-->
    </script>
    <script type=\"text/javascript\">
    <!--
            var pageTracker = _gat._getTracker(\"UA-3880720-1\");
            pageTracker._initData();
            pageTracker._trackPageview();
    //-->
    </script>"
  end
end
