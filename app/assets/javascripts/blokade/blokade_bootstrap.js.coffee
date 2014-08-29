jQuery ->
  # Allow linking to specific Bootstrap Tabs
  # Javascript to enable link to tab
  url = document.location.toString()
  url_split = url.split("#")
  if url_split
    url_parts = url_split[1]
    if url_parts
      url_fragments = url_parts.split("-")
      if url_fragments.length is 1
        $(".nav-paginate-tabs a[href=#" + url_fragments[0] + "]").tab "show"  if url.match("#")
      else if url_fragments.length is 2
        console.log("fragments is: ", url_fragments)
        $(".nav-paginate-tabs a[href=#" + url_fragments[0] + "]").tab "show"  if url.match("#")
        $(".nav-paginate-tabs a[href=#" + url_fragments[1] + "]").tab "show"  if url.match("_")

  # Change hash for page-reload
  $("a[data-toggle=\"tab\"]").on "show.bs.tab", (e) ->
    window.location.hash = e.target.hash
