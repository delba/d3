draw = (data) ->
  console.log data
  d3.select('body')
    .append('div')
    .attr('class', 'chart')
    .selectAll('.bar')
    .data(data.cash)
    .enter()
    .append('div')
    .attr('class', 'bar')
    .style('width', (d) -> "#{d.count/100}px")
    .text (d) -> Math.round d.count

d3.json('plaza_traffic.json', draw)
