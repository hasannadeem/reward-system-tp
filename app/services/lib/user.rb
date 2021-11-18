# frozen_string_literal: true

# class for user
class User
  attr_accessor :name, :id, :points, :inviter_name, :is_accept

  BASE_VALUE = 0.5
  @@count = 0

  def initialize(name, is_accept = false)
    @id = User.count + 1
    @name = name
    @points = 0
    @inviter_name = nil
    @is_accept = is_accept

    puts "Customer has been Initialized with name #{@name}"

    @@count += 1
  end

  def self.count
    @@count
  end

  def invite(user)
    if name == user.name
      puts "-----------------------#{user.name} cann't invite yourself-----------------------"
      return
    end

    if user.is_accept
      puts "#{user.name} already exist"
    else
      invite_user(user)
    end
  end

  def accept_invitation(users)
    if is_accept
      puts "#{name} have already signed up"
    else
      self.is_accept = true
      level = 0
      inviter_name = self.inviter_name

      calculate_points(users, level, inviter_name)
    end
  end

  def self.data(users)
    reward_data = {}

    users.each_value do |user|
      reward_data[user.name] = user.points
    end

    reward_data
  end

  private

  def calculate_points(users, level, inviter_name)
    loop do
      break if inviter_name.nil?

      users[:"#{inviter_name}"].points = users[:"#{inviter_name}"].points + BASE_VALUE**level
      inviter_name = users[:"#{inviter_name}"].inviter_name
      level += 1
    end
  end

  def invite_user(user)
    puts "Invitation has been send to user: #{user.name} from user: #{name}"
    user.inviter_name = name if user.inviter_name.nil?
  end
end
