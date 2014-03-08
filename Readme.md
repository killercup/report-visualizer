# Report Visualizer

Server-less web app to display data gathered by [Reporter].

**[Live Version](http://killercup.github.io/report-visualizer/)**

[Reporter]: http://www.reporter-app.com/

## Workflow

- Import data using the files Reporter saved to your Dropbox.
- See charts for all the questions you added in Reporter.
- Available chart types:
    - Stacked bar chart
    - Vertical bar chart
    - Punch chart (hour/weekday and report impetus/weekday)

## Privacy

There is no server. All the data you 'uploaded' is in fact just read by your browser and stored until you close the browser window. All analyzing happens on your own computer and nothing is send to any third party.

## Technology

- HTML5 FileReader API (only works in browsers that support this)
- [React.js](http://facebook.github.io/react/)
- [CoffeeScript](http://coffeescript.org/)
- [lodash](http://lodash.com/)
- [browserify](http://browserify.org/)

## Related

- [Reporter Save File Schema](https://gist.github.com/dbreunig/9315705).

## License

MIT
