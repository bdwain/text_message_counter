$.tablesorter.addWidget({
    id: "numbering",
    format: function(table) {
        var c = table.config;
        $("tr:visible", table.tBodies[0]).each(function(i) {
            $(this).find('td').eq(0).text(i + 1);
        });
    }
});

$(document).ready(function(){
  $("#results").tablesorter({
    headers: { 0: { sorter: false}},
    widgets: ['numbering', 'zebra']
  });
});