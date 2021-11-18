# frozen_string_literal: true

$LOAD_PATH << "#{Rails.root}/app/services/lib/"
require('user')

# class for reward service
class RewardService
  attr_accessor :users

  def self.call(*args, &block)
    new(*args, &block).execute
  end

  def initialize(file, users = {})
    @file = file
    @users = users
  end

  def execute
    return 'No data available' if @file.nil?

    data = IO.readlines(@file)
    calculate_reward(data)
  end

  private

  def calculate_reward(rows)
    rows.each do |row|
      columns = row.split(' ')

      next unless columns.length.between?(4, 5)

      segregate_user(columns)
    end

    User.data(@users)
  end

  def segregate_user(columns)
    case columns[3].downcase
    when 'recommend'
      @users = invite_user(columns[2], columns[4])
    when 'accept'
      @users = accept_invitation(columns[2])
    else
      puts "Wrong input line #{columns.join(' ')}"
    end

    @users
  end

  def invite_user(inviter, invitee)
    @users.merge!({ "#{inviter}": User.new(inviter, true) }) if @users[:"#{inviter}"].nil?
    @users.merge!({ "#{invitee}": User.new(invitee) }) if @users[:"#{invitee}"].nil?
    @users[:"#{inviter}"].invite(@users[:"#{invitee}"]) if @users[:"#{inviter}"].is_accept

    @users
  end

  def accept_invitation(invitee)
    @users.merge!({ "#{invitee}": User.new(invitee, true) }) if @users[:"#{invitee}"].nil?
    @users[:"#{invitee}"].accept_invitation(@users)

    @users
  end
end
