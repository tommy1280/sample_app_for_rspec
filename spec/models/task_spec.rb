require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    it 'is valid with all attributes' do
      task = FactoryBot.build(:task)
      expect(task).to be_valid
    end

    it 'is invalid without title' do
      task_without_title = FactoryBot.build(:task, title: nil)
      expect(task_without_title).to be_invalid
      expect(task_without_title.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without status' do
      task_without_status = FactoryBot.build(:task, status: nil)
      expect(task_without_status).to be_invalid
      expect(task_without_status.errors[:status]).to include("can't be blank")

    end

    it 'is invalid with a duplicate title' do
      task = FactoryBot.create(:task)
      task_with_duplicate_title  = FactoryBot.build(:task, content: "要件コピー", status: 'doing', deadline: Time.now.yesterday )
      expect(task_with_duplicate_title).to be_invalid
      expect(task_with_duplicate_title.errors[:title]).to eq ["has already been taken"]
    end

    it 'is valid with another title' do
      task = FactoryBot.create(:task)
      task_with_another_title = FactoryBot.build(:task, title: 'another_title')
      expect(task_with_another_title).to be_valid
    end
  end
end
