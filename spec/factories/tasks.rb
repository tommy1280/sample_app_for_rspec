FactoryBot.define do
  factory :task do
    content {'要件'}
    title {'基礎編課題'}
    status {'todo'}
    deadline { Time.now }
    association :user
  end
end
