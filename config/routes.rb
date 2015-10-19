require 'api_constraints'

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
    scope module: :vi, constraints: ApiConstraints.new(version: 1, default: true) do

    end
  end
end
