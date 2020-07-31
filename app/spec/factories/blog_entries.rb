FactoryGirl.define do
  factory :blog_entry, class: 'Spree::BlogEntry' do
    preview_text 'MyText'
    full_text 'MyText'
    user { create :blog_user }
    view_count 1
    posted_on '2016-05-03'
    title 'MyTitle'
  end
end
