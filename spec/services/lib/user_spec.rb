# frozen_string_literal: true

require 'rails_helper'
require_relative '../../../app/services/lib/user'

RSpec.describe 'User', type: :system do
  describe '#invite' do
    it 'when A invite A' do
      inviter = User.new('A', true)
      result = inviter.invite(inviter)
      expect(result).to eq(nil)
    end
  end

  describe '#invite' do
    it 'when B invite C' do
      inviter = User.new('B', true)
      invitee = User.new('C')
      inviter.invite(invitee)

      expect(invitee.inviter_name).to eq('B')
    end
  end

  describe '#invite' do
    it 'when multiple invitation' do
      inviter1 = User.new('B', true)
      inviter2 = User.new('C', true)
      invitee = User.new('D')
      inviter1.invite(invitee)
      inviter2.invite(invitee)

      expect(invitee.inviter_name).to eq('B')
    end
  end

  describe '#accept_invitation' do
    let(:users) { { A: User.new('A', true), B: User.new('B', true) } }

    it 'when user already exist' do
      expect(users[:B].accept_invitation(users)).to eq(nil)
    end
  end

  describe '#accept_invitation' do
    let(:users) { { A: User.new('A', true), B: User.new('B'), C: User.new('C'), D: User.new('D') } }

    it 'when D accept invitation' do
      users[:A].invite(users[:B])
      users[:B].accept_invitation(users)
      users[:B].invite(users[:C])
      users[:C].accept_invitation(users)
      users[:C].invite(users[:D])
      users[:B].invite(users[:D])
      users[:D].accept_invitation(users)

      expect(users[:A].points).to eq(1.75)
      expect(users[:B].points).to eq(1.5)
      expect(users[:C].points).to eq(1)
      expect(users[:D].points).to eq(0)
    end
  end

  describe '#data' do
    let(:users) { { A: User.new('A', true), B: User.new('B'), C: User.new('C'), D: User.new('D') } }
    it 'show data' do
      users[:A].invite(users[:B])
      users[:B].accept_invitation(users)
      users[:B].invite(users[:C])
      users[:C].accept_invitation(users)
      users[:C].invite(users[:D])
      users[:B].invite(users[:D])
      users[:D].accept_invitation(users)

      expect(User.data(users)).to eq({ 'A' => 1.75, 'B' => 1.5, 'C' => 1, 'D' => 0 })
    end
  end

  describe '#calculate_points' do
    let(:users) { { A: User.new('A', true), B: User.new('B'), C: User.new('C'), D: User.new('D') } }
    it 'when D accept' do
      users[:A].invite(users[:B])
      users[:B].is_accept = true
      users[:B].send(:calculate_points, users, 0, users[:B].inviter_name)
      users[:B].invite(users[:C])
      users[:B].invite(users[:C])
      users[:C].is_accept = true
      users[:C].send(:calculate_points, users, 0, users[:C].inviter_name)
      users[:C].invite(users[:D])
      users[:B].invite(users[:D])
      users[:D].is_accept = true
      users[:D].send(:calculate_points, users, 0, users[:D].inviter_name)

      expect(users[:A].points).to eq(1.75)
      expect(users[:B].points).to eq(1.5)
      expect(users[:C].points).to eq(1)
      expect(users[:D].points).to eq(0)
    end
  end

  describe '#invite_user' do
    let(:users) { { A: User.new('A', true), B: User.new('B') } }
    it 'when A invite B' do
      users[:A].send(:invite_user, users[:B])

      expect(users[:B].inviter_name).to eq('A')
    end
  end
end
