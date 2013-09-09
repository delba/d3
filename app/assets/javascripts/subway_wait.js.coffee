time_scale = null
percent_scale = null

draw_timeseries = (data, id) ->
  line = d3.svg.line()
    .x( (d) -> time_scale(d.time) )
    .y( (d) -> percent_scale(d.late_percent) )
    .interpolate('linear')

  g = d3.select('#chart')
    .append('g')
    .attr('id', "#{id}_path")
    .attr('class', id.split('_')[1])

  g.append('path')
    .attr('d', line(data))

draw = (data) ->
  console.log data

  container_dimensions =
    width: 900
    height: 400

  margins =
    top: 10
    right: 20
    bottom: 30
    left: 60

  chart_dimensions =
    width: container_dimensions.width - margins.left - margins.right
    height: container_dimensions.height - margins.top - margins.bottom

  chart = d3.select('#timeseries')
    .append('svg')
    .attr('width', container_dimensions.width)
    .attr('height', container_dimensions.height)
    .append('g')
    .attr('transform', "translate(#{margins.left}, #{margins.top})")
    .attr('id', 'chart')

  time_scale = d3.time.scale()
    .range([0, chart_dimensions.width])
    .domain([new Date(2009, 0, 1), new Date(2011, 3, 1)])

  percent_scale = d3.scale.linear()
    .range([chart_dimensions.height, 0])
    .domain([65, 90])

  time_axis = d3.svg.axis()
    .scale(time_scale)

  count_axis = d3.svg.axis()
    .scale(percent_scale)
    .orient('left')

  chart.append('g')
    .attr('class', 'x axis')
    .attr('transform', "translate(0, #{chart_dimensions.height})")
    .call(time_axis)

  chart.append('g')
    .attr('class', 'y axis')
    .call(count_axis)

  d3.select('.y.axis')
    .append('text')
    .attr('text-anchor', 'middle')
    .text('percent on time')
    .attr('transform', 'rotate(-270, 0, 0)')
    .attr('x', container_dimensions.height / 2)
    .attr('y', 50)

  key_items = d3.select('#key')
    .selectAll('div')
    .data(data)
    .enter()
    .append('div')
    .attr('class', 'key_line')
    .attr('id', (d) -> d.line_id)

  key_items.append('div')
    .attr('id', (d) -> "key_square_#{d.line_id}")
    .attr('class', 'key_square')

  key_items.append('div')
    .attr('class', 'key_label')
    .text (d) -> d.line_name

  get_timeseries_data = ->
    # get the id of the current element
    id = d3.select(this).attr('id')

    # see if we have an associated time series
    ts = d3.select("##{id}_path")
    if ts.empty()
      d3.json('subway_wait.json', (data) ->
        filtered_data = data.filter( (d) -> d.line_id is id )
        draw_timeseries(filtered_data, id)
      )
    else
      ts.remove()

  d3.selectAll('.key_line')
    .on('click', get_timeseries_data)

d3.json 'subway_wait_mean.json', draw
