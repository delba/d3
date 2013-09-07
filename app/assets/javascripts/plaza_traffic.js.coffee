draw = (data) ->
  d3.select('body')
    .append('div')
    .attr('class', 'chart')
    .selectAll('div.line')
    .data(data.cash)
    .enter()
    .append('div')
    .attr('class', 'line')

  d3.selectAll('div.line')
    .append('div')
    .attr('class', 'label')
    .text((d) -> d.name)

  d3.selectAll('div.line')
    .append('div')
    .attr('class', 'bar')
    .style('width', (d) -> "#{d.count/100}px")
    .text (d) -> Math.round d.count

d3.json('plaza_traffic.json', draw)
