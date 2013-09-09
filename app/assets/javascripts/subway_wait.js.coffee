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
    .attr('class', id)

  g.append('path')
    .attr('d', line(data))
    .attr('class', "#{id} line")

  g.selectAll('circle')
    .data(data)
    .enter()
    .append('circle')
    .attr('cx', (d) -> time_scale(d.time))
    .attr('cy', (d) -> percent_scale(d.late_percent))
    .attr('r', 0)


  add_label = (circle, d) ->
    d3.select(circle)
      .transition()
      .attr('r', 9)
    g.append('text')
      .text(d.line_id.split('_')[1])
      .attr('x', time_scale(d.time))
      .attr('y', percent_scale(d.late_percent))
      .attr('dy', '0.35em')
      .attr('class', 'linelabel')
      .attr('text-anchor', 'middle')
      .style('opacity', 0)
      .style('fill', 'white')
      .transition()
      .style('opacity', 1)

  enter_duration = 1000

  g.selectAll('circle')
    .transition()
    .delay( (d, i) -> i / data.length * enter_duration )
    .attr('r', 5)
    .each 'end', (d, i) ->
      if i is data.length - 1
        add_label this, d

  g.selectAll('circle')
    .on('mouseover', (d) ->
      d3.select(this)
        .transition()
        .attr('r', 9)
    )
    .on('mouseout', (d, i) ->
      if i isnt data.length - 1
        d3.select(this)
          .transition()
          .attr('r', 5)
    )

  g.selectAll('circle')
    .on('mouseover.tooltip', (d) ->
      d3.select("text.#{d.line_id}").remove()
      d3.select('#chart')
        .append('text')
        .text("#{d.late_percent}%")
        .attr('x', time_scale(d.time) + 10)
        .attr('y', percent_scale(d.late_percent))
        .attr('class', d.line_id)
    )
    .on('mouseout.tooltip', (d) ->
      d3.select("text.#{d.line_id}")
        .transition()
        .duration(500)
        .style('opacity', 0)
        .attr('transform', 'translate(10, -10)')
        .remove()
    )

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
    .attr('class', (d) -> "key_square #{d.line_id}")

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
