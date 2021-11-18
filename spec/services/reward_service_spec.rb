# frozen_string_literal: true

require 'rails_helper'
require_relative '../../app/services/reward_service/'

RSpec.describe RewardService, type: :system do
  describe '#execute' do
    let(:file) { fixture_file_upload("#{Rails.root}/spec/files/input.txt") }

    it 'with no file' do
      expect(RewardService.new(nil).execute).to eq('No data available')
    end

    it 'with a file' do
      expect(RewardService.new(file).execute).to eq({ 'A' => 1.75, 'B' => 1.5, 'C' => 1, 'D' => 0, 'E' => 0 })
    end
  end

  describe '#calculate_reward' do
    let(:file) { fixture_file_upload("#{Rails.root}/spec/files/input.txt") }

    context 'with valid input rows' do
      let(:rows) do
        ["2018-06-12 09:41 A Recommend B\n",
         "2018-06-14 09:41 B Accept\n",
         "2018-06-16 09:41 B Recommend C\n",
         "2018-06-17 09:41 C Accept\n",
         "2018-06-19 09:41 C Recommend D\n",
         "2018-06-23 09:41 B Recommend D\n",
         "2018-06-25 09:41 D Accept\n",
         "2018-06-25 09:41 E Accept\n",
         "2018-06-23 09:41 F Recommend L and P\n"]
      end

      it 'when input rows are valid' do
        expect(RewardService.new(file).send(:calculate_reward,
                                            rows)).to eq({ 'A' => 1.75, 'B' => 1.5, 'C' => 1, 'D' => 0,
                                                           'E' => 0 })
      end
    end
  end

  describe '#calculate_reward' do
    let(:file) { fixture_file_upload("#{Rails.root}/spec/files/input.txt") }

    context 'with empty rows' do
      let(:rows) do
        []
      end

      it 'when no input row' do
        expect(RewardService.new(file).send(:calculate_reward,
                                            rows)).to eq({})
      end
    end
  end

  describe '#calculate_reward' do
    let(:file) { fixture_file_upload("#{Rails.root}/spec/files/input.txt") }

    context 'with invalid rows' do
      let(:rows) do
        [
          "2018-06-23 09:41 F Recommend L and P\n"
        ]
      end

      it 'when row length > 5 ' do
        expect(RewardService.new(file).send(:calculate_reward,
                                            rows)).to eq({})
      end
    end

    context 'with valid and invalid rows' do
      let(:rows) do
        ["2018-06-12 09:41 A Recommend B\n",
         "2018-06-14 09:41 B Accept\n",
         "2018-06-16 09:41 B Recommend C\n",
         "2018-06-23 09:41 F Recommend L and P\n"]
      end

      it 'when mixed row data' do
        expect(RewardService.new(file).send(:calculate_reward,
                                            rows)).to eq({ 'A' => 1, 'B' => 0, 'C' => 0 })
      end
    end
  end

  describe '#segregate_user' do
    let(:file) { fixture_file_upload("#{Rails.root}/spec/files/input.txt") }

    context '1 line manipulation' do
      let(:users) { {} }
      let(:columns) do
        [
          '2018-06-12',
          '09:41',
          'A',
          'Recommend',
          'B'
        ]
      end

      it 'when line input is valid' do
        expect(RewardService.new(file, users).send(:segregate_user,
                                                   columns).keys).to eq(%i[A B])
      end
    end

    context '4rth word' do
      let(:users) { {} }
      let(:columns) do
        [
          '2018-06-12',
          '09:41',
          'A',
          'Recommends',
          'B'
        ]
      end

      it 'when 4rth word is invalid' do
        expect(RewardService.new(file, users).send(:segregate_user,
                                                   columns)).to eq({})
      end
    end
  end

  describe '#invite_user' do
    let(:file) { fixture_file_upload("#{Rails.root}/spec/files/input.txt") }

    it 'when A Recommend B' do
      expect(RewardService.new(file).send(:invite_user,
                                          'A', 'B').keys).to eq(%i[A B])
    end

    it 'When A Recommend A' do
      expect(RewardService.new(file).send(:invite_user,
                                          'A', 'A').keys).to eq(%i[A])
    end
  end

  describe '#accept_invitation' do
    let(:file) { fixture_file_upload("#{Rails.root}/spec/files/input.txt") }

    it 'When B accept' do
      expect(RewardService.new(file).send(:accept_invitation,
                                          'B').keys).to eq(%i[B])
    end
  end
end
