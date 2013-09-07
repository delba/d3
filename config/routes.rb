D3::Application.routes.draw do
  controller :dashboard do
    get 'service_status'
  end
end
