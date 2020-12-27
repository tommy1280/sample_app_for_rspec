require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user) { create(:user) }
  let(:task) { create(:task) }

  describe 'ログイン前' do
    describe 'ページ遷移' do
      context 'タスクの新規登録ページへアクセス' do
        it 'タスクの新規登録ページへのアクセスが失敗する' do
          visit new_task_path
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end

      context 'タスクの編集ページへアクセス' do
        it 'タスクの編集ページへのアクセスが失敗する' do
          visit edit_task_path(task)
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end

      context 'タスクの詳細ページへアクセス' do
        it 'タスクの詳細ページへのアクセスが成功する' do
          visit task_path(task)
          expect(page).to have_content task.title
          expect(current_path).to eq task_path(task)
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }

    describe 'タスクの新規登録' do
      context 'フォームの入力値が正常値' do
        it 'タスクの新規登録が成功する' do
          visit new_task_path
          fill_in 'Title', with: 'テストタイトル'
          fill_in 'Content', with:  'テストコンテント'
          select 'doing', from: 'Status'
          fill_in 'Deadline', with: DateTime.new(2020, 12, 25, 8, 40)
          click_button 'Create Task'
          expect(page).to have_content 'Task was successfully created.'
          expect(current_path).to eq '/tasks/1'
        end
      end

      context 'フォームにタイトルが未入力' do
        it 'タスクの新規登録が失敗する' do
          visit new_task_path
          fill_in 'Title', with: ''
          fill_in 'Content', with:  'テストコンテント'
          select 'doing', from: 'Status'
          fill_in 'Deadline', with: DateTime.new(2020, 12, 25, 8, 40)
          click_button 'Create Task'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq tasks_path
        end
      end

      context 'フォームに登録済のタイトルを入力' do
        it 'タスクの新規作成が失敗する' do
          visit new_task_path
          another_task = create(:task)
          fill_in 'Title', with: another_task.title
          fill_in 'Content', with:  ''
          select 'doing', from: 'Status'
          fill_in 'Deadline', with: DateTime.new(2020, 12, 25, 8, 40)
          click_button 'Create Task'
          expect(page).to have_content "Title has already been taken"
          expect(current_path).to eq tasks_path
        end
      end

      context 'タスクの新規登録ページへアクセス' do
        it 'タスクの新規登録ページへのアクセスが成功する' do
          visit new_task_path
          expect(current_path).to eq new_task_path
        end
      end
    end

    describe 'タスクの編集' do
      let!(:task) { create(:task, user: user) }
      let(:another_task) { create(:task, user: user) }
      before { visit edit_task_path(task) }

      context 'フォームの入力値が正常値' do
        it 'タスクの編集が成功する' do
          fill_in 'Title', with: '編集テストタイトル'
          click_button 'Update Task'
          expect(page).to have_content 'Task was successfully updated.'
          expect(current_path).to eq task_path(task)
        end
      end

      context 'フォームにタイトルが未入力' do
        it 'タスクの編集が失敗する' do
          fill_in 'Title', with: ''
          click_button 'Update Task'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq task_path(task)
        end
      end

      context 'フォームに登録済のタイトルを入力' do
        it 'タスクの編集が失敗する' do
          fill_in 'Title', with: another_task.title
          click_button 'Update Task'
          expect(page).to have_content "Title has already been taken"
          expect(current_path).to eq task_path(task)
        end
      end
    end

    describe 'タスクの削除' do
      let!(:task) {create(:task, user: user)} 
      
      it "タスクの削除成功" do
        visit tasks_path
        click_link 'Destroy'
        expect(page.accept_confirm)
        expect(page).to have_content 'Task was successfully destroyed.'
        expect(current_path).to eq tasks_path
        expect(page).to have_no_content task.title
      end
    end
  end
end
