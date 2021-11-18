# frozen_string_literal: true

$LOAD_PATH << "#{Rails.root}/app/services/"
require('reward_service')

# reward controller
class RewardsController < ApplicationController
  before_action :set_reward, only: :index

  def index; end

  def create
    @reward = RewardService.call(params[:file])

    redirect_to root_path(reward: @reward)
  end

  private

  def set_reward
    @reward = params[:reward]
  end
end
