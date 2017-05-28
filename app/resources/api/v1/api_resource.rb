module Api
  module V1
    class ApiResource < JSONAPI::Resource
      include JSONAPI::Authorization::PunditScopedResource
      abstract
    end
  end
end