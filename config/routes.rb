D3::Application.routes.draw do
  controller :dashboard do
    get 'service_status'
    get 'plaza_traffic'
    get 'bus_perf'
    get 'turnstile_traffic'
    get 'subway_wait'
    get 'subway_wait_mean'
    get 'stations_graph'
    get 'interarrival_times'
  end
end
