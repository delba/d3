draw = (data) ->
  console.log data

  margin = 50
  width  = 700 - margin
  height = 300 - margin

  d3.select('body')
    .append('svg')
    .attr('width', width + margin)
    .attr('height', height + margin)
    .append('g')
    .attr('class', 'chart')

  d3.select('svg')
    .selectAll('circle.times_square')
    .data(data.times_square)
    .enter()
    .append('circle')
    .attr('class', 'times_square')

  d3.select('svg')
    .selectAll('circle.grand_central')
    .data(data.grand_central)
    .enter()
    .append('circle')
    .attr('class', 'grand_central')

  count_extent = d3.extent(
    data.times_square.concat(data.grand_central), (d) ->
      d.count
  )

  count_scale = d3.scale.linear()
    .domain(count_extent)
    .range([height, margin])

  d3.selectAll('circle')
    .attr('cy', (d) -> count_scale(d.count))

  time_extent = d3.extent(
    data.times_square.concat(data.grand_central), (d) ->
      d.time
  )

  time_scale = d3.time.scale()
    .domain(time_extent)
    .range([margin, width])

  d3.selectAll('circle')
    .attr('cx', (d) -> time_scale(d.time))
    .attr('cy', (d) -> count_scale(d.count))
    .attr('r', 3)

  time_axis = d3.svg.axis()
    .scale(time_scale)

  d3.select('svg')
    .append('g')
    .attr('class', 'x axis')
    .attr('transform', "translate(0, #{height})")
    .call(time_axis)

  count_axis = d3.svg.axis()
    .scale(count_scale)
    .orient('left')

  d3.select('svg')
    .append('g')
    .attr('class', 'y axis')
    .attr('transform', "translate(#{margin}, 0)")
    .call(count_axis)

d3.json('turnstile_traffic.json', draw)
