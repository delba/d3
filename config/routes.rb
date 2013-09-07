D3::Application.routes.draw do
  controller :dashboard do
    get 'service_status'
    get 'plaza_traffic'
  end
end
