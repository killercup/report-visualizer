L = require('lazy')
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
      props = L(D.getDistribution(@props.responses, @props.aspect))
        .defaults(@props)
        .toObject()

    (ChartTypes.StackedBar props, [])

SpecificCharts.StackedByWeekday = React.createClass
  displayName: "StackedByWeekdayReporterChart"
  getDefaultProps: ->
    weekdays: numberedWeekdays
    grouping: (snap) ->
      d = new Date(snap.date)
      d.getDay()

  render: ->
    props = L({}).defaults(@props).toObject()
    snaps = @props.snapshots.filter (snap) -> typeof snap.date is 'string'

    responsesObject = {}
    responses = L(@props.snapshots)
      .pluck('responses')
      .flatten()
      .where(questionPrompt: @props.aspect)
      .map(D.getAnswersFromResponse)
      .uniq()
      .sortBy()
      .each (r) ->
        responsesObject[r] = 0

    props.distribution or= D.getGroupedDistribution(
      snaps,
      @props.grouping,
      @props.aspect
    )

    props.distribution = L(props.distribution)
    .map ([key, answerCount]) ->
      [key, L(answerCount).defaults(responsesObject).toObject()]
    .sortBy ([key, a]) -> key
    .toArray()

    props.xValues or= @props.weekdays.sort()
    props.width = 2 * 260 + 40

    (ChartTypes.StackedBars props, [])

SpecificCharts.VerticalBars = React.createClass
  displayName: "VerticalBarsReporterChart"

  render: ->
    if @props.distribution
      props = @props
    else
      props = L(D.getDistribution(@props.responses, @props.aspect))
        .defaults(@props)
        .toObject()

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

    snaps = @props.snapshots.filter (snap) ->
      # only reports in newer format
      snap.reportImpetus and (typeof snap.date is 'string')

    dist = L(D.aggregatePunch snaps, getIndex, @props.aspect, counting)
      .map @props.entryToLabels
      .toArray()

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

    snaps = @props.snapshots.filter (snap) ->
      # only reports in newer format
      typeof snap.date is 'string'

    dist = D.aggregatePunch(snaps, getIndex, @props.aspect, counting)
      .map @props.entryToLabels

    (ChartTypes.PunchChart {
      aspect: @props.aspect
      yValues: @props.yValues
      distribution: dist
      width: 2 * 260 + 40
      padding: l: 60, b: 30, r: 0, t: 0
    })

module.exports = SpecificCharts
