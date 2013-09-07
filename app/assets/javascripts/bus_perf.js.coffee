draw = (data) ->
  console.log data

  width  = 700
  height = 300
  margin = 50

  d3.select('body')
    .append('svg')
    .attr('width', width)
    .attr('height', height)
    .selectAll('circle')
    .data(data)
    .enter()
    .append('circle')

  # d3.extent is a convenience function that D3 provides that
  # returns the minimum and maximum values of its arguments
  # — which in this case is the collisions with injury rate
  x_extent = d3.extent data, (d) -> d.collision_with_injury

  # map the extent of the data onto the range [50, 660]
  # => x_scale is a function that accepts numbers between the minimum
  # and maximum values of the data (x_extent) and outputs number
  # between 50 and 650
  x_scale = d3.scale.linear()
    .range([margin, width - margin])
    .domain(x_extent)

  # same stuff for y axis
  y_extent = d3.extent data, (d) -> d.dist_between_fail
  y_scale = d3.scale.linear()
    .range([height - margin, margin]) # 0 is top-left => reverse
    .domain(y_extent)

  # position the circles
  d3.selectAll('circle')
    .attr('cx', (d) -> x_scale(d.collision_with_injury))
    .attr 'cy', (d) -> y_scale(d.dist_between_fail)

  # give a radius to the circles
  d3.selectAll('circle')
    .attr('r', 5)

  # Adding axis
  x_axis = d3.svg.axis().scale(x_scale)

  d3.select('svg')
    .append('g')
    .attr('class', 'x axis')
    # move the axis down to the bottom of the graph
    .attr('transform', "translate(0, #{height - margin})")
    .call(x_axis)

  y_axis = d3.svg.axis().scale(y_scale).orient('left')

  d3.select('svg')
    .append('g')
    .attr('class', 'y axis')
    .attr('transform', "translate(#{margin}, 0)")
    .call(y_axis)

  # Adding Axis title

  d3.select('.x.axis')
    .append('text')
    .text('collisions with injury (per million miles)')
    .attr('x', (width / 2) - margin)
    .attr('y', margin / 1.5)

  d3.select('.y.axis')
    .append('text')
    .text('mean distance between failure (miles)')
    .attr('transform', 'rotate(-90, -43, 0) translate(-280)')

d3.json('bus_perf.json', draw)
