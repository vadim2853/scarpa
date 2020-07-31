FactoryGirl.define do
  factory :comment, class: 'Spree::Comment' do
    comment 'MyText'
    user { create :blog_user }
    commentable { create :blog_entry }
    root_commentable_id { commentable.try(:root_commentable_id) || commentable.id }
  end
end
