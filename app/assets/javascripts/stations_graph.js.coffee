draw = (data) ->
  width  = 1500
  height = 1500

  svg = d3.select('body')
    .append('svg')
    .attr('width', width)
    .attr('height', height)

  node = svg.selectAll('circle.node')
    .data(data.nodes)
    .enter()
    .append('circle')
    .attr('class', 'node')
    .attr('r', 12)

  link = svg.selectAll('line.link')
    .data(data.links)
    .enter()
    .append('line')
    .attr('class', 'link')
    .style('stroke', 'black')

  force = d3.layout.force()
    .charge(-120)
    .linkDistance(30)
    .size([width, height])
    .nodes(data.nodes)
    .links(data.links)
    .start()

  force.on 'tick', ->
    console.log 'tick'
    link.attr('x1', (d) -> d.source.x)
      .attr('y1', (d) -> d.source.y)
      .attr('x2', (d) -> d.target.x)
      .attr('y2', (d) -> d.target.y)
    node.attr('cx', (d) -> d.x)
      .attr('cy', (d) -> d.y)

  node.call(force.drag)

d3.json('stations_graph.json', draw)
