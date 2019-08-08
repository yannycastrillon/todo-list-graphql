require 'rails_helper'

RSpec.describe TodoList, type: :model do
  it 'has a valid factory' do
    expect(build(:todo_list)).to be_valid
  end

  let(:attributes) do
    {
      title: 'A test title'
    } 
  end

  let(:todo_list) { create(:todo_list, **attributes) }

  describe 'Model validation' do
    it { expect(todo_list).to allow_value(attributes[:title]).for(:title) }
    # ensure that the title field is never empty
    it { expect(todo_list).to validate_presence_of(:title) }
    # ensure that the title is unique for each todo list
    it { expect(todo_list).to validate_uniqueness_of(:title) }
  end

  describe 'model association' do
    it { expect(todo_list).to have_many(:items) }
  end
end
