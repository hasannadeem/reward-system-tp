# frozen_string_literal: true

Rails.application.routes.draw do
  root 'rewards#index'

  resource :reward, only: %i[index create]
end
