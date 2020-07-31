FactoryGirl.define do
  factory :news_entry, class: 'Spree::NewsEntry' do
    title 'MyTitle'
    preview_text 'MyText'
    full_text 'MyText'
    view_count 1
    posted_on '2016-05-05'
    status Spree::NewsEntry.statuses[:published]
  end
end
