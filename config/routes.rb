D3::Application.routes.draw do
  controller :dashboard do
    get 'service_status'
    get 'plaza_traffic'
    get 'bus_perf'
    get 'turnstile_traffic'
  end
end
