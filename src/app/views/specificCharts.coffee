_ = require('lodash')
React = require('react')

ChartTypes = require('../charts')
D = require('../reporter/distributions')

numberedWeekdays = ['7 Sun', '1 Mon', '2 Tue', '3 Wed', '4 Thu', '5 Fri', '6 Sat']
impetues = ['Tapped', 'Sleeping', 'Day', 'Dusk', 'Dawn']

SpecificCharts = {}

SpecificCharts.Stacked = React.createClass
  displayName: "StackedReporterChart"
  render: ->
    if @props.distribution
      props = @props
    else
      props = _.defaults(D.getDistribution(@props.responses, @props.aspect), @props)

    (ChartTypes.StackedBar props, [])

SpecificCharts.StackedByWeekday = React.createClass
  displayName: "StackedByWeekdayReporterChart"
  getDefaultProps: ->
    weekdays: numberedWeekdays
    grouping: (snap) ->
      d = new Date(snap.date)
      d.getDay()

  render: ->
    props = _.clone(@props)
    snaps = _.filter(@props.snapshots, (snap) -> _.isString(snap.date))

    responsesObject = {}
    responses = _(@props.snapshots)
      .pluck('responses')
      .flatten()
      .where(questionPrompt: @props.aspect)
      .map(D.getAnswersFromResponse)
      .unique()
      .sort()
      .each (r) ->
        responsesObject[r] = 0

    props.distribution or= D.getGroupedDistribution(
      snaps,
      @props.grouping,
      @props.aspect
    )

    props.distribution = _(props.distribution)
    .map ([key, answerCount]) ->
      [key, _.defaults(answerCount, responsesObject)]
    .sortBy ([key, a]) -> key
    .value()

    props.xValues or= _.sortBy @props.weekdays
    props.width = 2 * 260 + 40

    (ChartTypes.StackedBars props, [])

SpecificCharts.VerticalBars = React.createClass
  displayName: "VerticalBarsReporterChart"

  render: ->
    if @props.distribution
      props = @props
    else
      props = _.defaults(D.getDistribution(@props.responses, @props.aspect), @props)

    (ChartTypes.VerticalBars props, [])

SpecificCharts.PunchImpetusWeekday = React.createClass
  displayName: "PunchImpetusWeekdayReporterChart"
  getDefaultProps: ->
    weekdays: numberedWeekdays
    impetues: impetues
    criteria: "Yes"
    getIndex: (snap) ->
      d = new Date(snap.date)
      [d.getDay(), snap.reportImpetus]
    entryToLabels: ([x, y, a]) =>
      [@props.weekdays[x], @props.impetues[y], a]

  render: ->
    getIndex = @props.getIndex
    counting = (i) => i is @props.criteria

    snaps = _.filter @props.snapshots, (snap) ->
      # only reports in newer format
      snap.reportImpetus and _.isString(snap.date)

    dist = _(D.aggregatePunch snaps, getIndex, @props.aspect, counting)
      .map @props.entryToLabels
      .value()

    (ChartTypes.PunchChart {
      aspect: @props.aspect
      distribution: dist
      width: 2 * 260 + 40
      padding: l: 60, b: 30, r: 0, t: 0
    })

SpecificCharts.PunchHourWeekday = React.createClass
  displayName: "PunchHourWeekdayReporterChart"
  getDefaultProps: ->
    weekdays: numberedWeekdays
    criteria: "Yes"
    yValues: [0..23]
    getIndex: (snap) ->
      d = new Date(snap.date)
      [d.getDay(), d.getHours()]
    entryToLabels: ([x, y, a]) => [@props.weekdays[x], y, a]

  render: ->
    getIndex = @props.getIndex
    counting = (i) => i is @props.criteria

    snaps = _.filter @props.snapshots, (snap) ->
      # only reports in newer format
      _.isString(snap.date)

    dist = _(D.aggregatePunch snaps, getIndex, @props.aspect, counting)
      .map @props.entryToLabels
      .value()

    (ChartTypes.PunchChart {
      aspect: @props.aspect
      yValues: @props.yValues
      distribution: dist
      width: 2 * 260 + 40
      padding: l: 60, b: 30, r: 0, t: 0
    })

module.exports = SpecificCharts