draw = (data) ->
  console.log data

  width = 800
  height = 300
  margin = 50

  stack = d3.layout.stack()

  bar_width = 2.2
  bar_max = 23

  histogram = d3.layout.histogram()
    .bins(d3.range(1.5, bar_max, bar_width))
    .frequency(false)

  lines = data.map (d) ->
    "Line_#{d.route_id}"

  counts = data.map (d) ->
    histogram(d.interarrival_times)

  nested_stat = (d, stat, accessor) ->
    stat(counts, (d) -> stat(d.map(accessor)))

  max_count = 2

  count_scale = d3.scale.linear()
    .domain([0, max_count])
    .range([height - margin, margin])
    .nice()

  x_scale = d3.scale.linear()
    .domain([
      nested_stat(counts, d3.min, (di) -> di.x),
      nested_stat(counts, d3.max, (di) -> di.x)
    ])
    .range([margin, width])

  xaxis = d3.svg.axis().scale(x_scale)
  yaxis = d3.svg.axis().scale(count_scale).orient('left')

  svg = d3.select('body')
    .append('svg')
    .attr('width', width)
    .attr('height', height)

  svg.selectAll('g')
    .data(stack(counts))
    .enter()
    .append('g')
    .attr('class', (d, i) -> lines[i])
    .selectAll('rect')
    .data((d) -> d)
    .enter()
    .append('rect')
    .attr('x', (d) -> x_scale(d.x))
    .attr('y', (d) -> count_scale(d.y) - (height - margin - count_scale(d.y0)))
    .attr('width', (d) -> x_scale(d.x + d.dx) - x_scale(d.x))
    .attr('height', (d) -> height - margin - count_scale(d.y))

  svg.append('g').attr('transform','translate(0,' + (height-margin) + ')').call(xaxis)

  svg.append('text').attr('x',x_scale(10)).attr('y', height - margin/5).text('scheduled wait time (minutes)')

d3.json('interarrival_times.json', draw)
