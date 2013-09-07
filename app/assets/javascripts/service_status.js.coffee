draw = (data) ->
  d3.select('body') # selects the body element of the page
    .append('ul') # appends an unnumbered list to the body (returns ul)
    .selectAll('li') # creates the `empty selection` (array with no element)
    .data(data) # joins the empty selection with each el of the data set
    .enter() # returns a selection whose array contains the data for all the new el that don't already have items on the page
    .append('li') # create list el for each d
    .text (d) -> # populate the list el
      "#{d.name}: #{d.status}"

  d3.selectAll('li')
    .style 'font-weight', (d) ->
      if d.status[0] is 'GOOD SERVICE' then 'normal' else 'bold'

d3.json('service_status.json', draw)
