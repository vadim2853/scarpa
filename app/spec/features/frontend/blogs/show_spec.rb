require 'rails_helper'

describe 'Blogs show', js: true do
  shared_context 'reply to first comment' do |message|
    When { find('.fa-reply', match: :first).click }
    When { find('div.article__leave_comment', match: :first) }
    When { all('div.article__leave_comment.level_1 > textarea')[1].set(message) }
    When { all('button', text: 'COMMENT')[1].click }
  end

  Given!(:blog_user) { create :blog_user }
  Given!(:april_entry) do
    create :blog_entry,
           posted_on: '2015.04.13',
           title: 'MyTitle',
           full_text: 'MyText',
           view_count: 1,
           user: blog_user
  end
  Given!(:comment1) { create :comment, commentable: april_entry, created_at: '04.04.2016', comment: 'comment1' }

  When { visit_as_adult blog_path(april_entry) }

  pending 'has all article details', js: false do
    Then { expect(find('.left_side')).to have_css('h2', text: 'MyTitle') }
    And  { expect(find('.left_side')).to have_css('.article__views', text: 2) }
    And  { expect(find('.left_side')).to have_css('.article__posted', text: 'Posted on : APRIL 13, 2015 by blogger') }
    And  { expect(find('.left_side')).to have_css('.article__text', text: 'MyText') }
  end

  context 'leave comment block present' do
    Then { expect(find('.article__comments')).to have_css('h4', text: 'LEAVE COMMENT :') }
    And  { expect(find('.article__comments')).to have_css('textarea') }
  end

  context 'has all comment details' do
    Then { expect(find('.left_side')).to have_css('.article__already_comments') }
    And  { expect(find('.article__already_comments')).to have_css('h4', text: '1 COMMENT :') }
    And  { expect(find('.article__comment', match: :first)).to have_css('.article_comment_name', text: 'blogger :') }
    And  { expect(find('.article__comment', match: :first)).to have_css('.article_comment_date', text: '01.03.2016') }
    And  { expect(find('.article__comment', match: :first)).to have_css('.article_comment_massage', text: 'comment1') }
  end

  context 'correctly counts comments' do
    Given { create :comment, commentable: april_entry }

    Then { expect(find('.article__already_comments')).to have_css('h4', text: '2 COMMENTS :') }
  end

  context 'not logged user' do
    context 'can not leave comments' do
      Then { expect(find('.article__comments')).to have_css('textarea[disabled]') }
      And { expect(find('.article__comments')).to have_css('.btn.red', text: 'LOGIN TO COMMENT') }
    end

    context 'can not see reply/delete buttons' do
      Then { expect(find('.article__already_comments')).to_not have_css('.article_comment_buttons') }
    end
  end

  context 'blogger user' do
    Given(:blogger) { create :blog_user }
    Given { login_as(blogger) }

    Then { expect(find('.article__already_comments')).to have_css('.article_comment_buttons') }

    context 'can reply' do
      When { visit_as_adult blog_path(april_entry) }
      include_context 'reply to first comment', 'bla bla'
      Then { expect(find('.article__already_comments')).to have_css('h4', text: '2 COMMENTS :') }
      And { expect(find('.article__comment.level_2')).to have_css('.article_comment_massage', text: 'bla bla') }
    end

    context 'can not see delete button' do
      Then { expect(find('.article__already_comments')).to_not have_css('i.fa-trash-o') }
    end

    context 'swap between reply buttons' do
      Given { create :comment, commentable: april_entry }
      When { visit_as_adult blog_path(april_entry) }

      context 'when click first reply button' do
        When { find('.article_comment_action', match: :first).click }
        Then { expect(page.all('.article__leave_comment').count).to eq(2) }
        And  { expect(page).to have_css('div.article__comment + div.article__leave_comment + div.article__comment') }
      end

      context 'when click second reply button' do
        When { find('.article_comment_action', match: :first) }
        When { all('.article_comment_action')[1].click }
        Then { expect(page).to have_css('.article__leave_comment', count: 2) }
        And  { expect(page).to have_css('.article__comment + .article__comment + .article__leave_comment') }
      end
    end
  end

  describe 'Comments deletion' do
    Given(:admin) { create :admin_user }
    Given { login_as(admin) }
    When { visit_as_adult blog_path(april_entry) }

    context 'delete first level comment' do
      Given { create :comment, commentable: april_entry, comment: 'comment1' }

      When { find('i.fa-trash-o', match: :first).click }
      When { find('i.fa-check-circle-o').click }
      Then { expect(page).to have_css('.article_comment_massage', text: 'comment1', count: 1) }
    end

    context 'delete second level comment' do
      include_context 'reply to first comment', 'reply to first comment'

      When { find('.level_2').find('i.fa-trash-o').click }
      When { find('i.fa-check-circle-o').click }
      Then { expect(page).to have_no_content('reply to first comment') }
      And  { expect(page).to have_content('comment1') }
    end

    context 'delete nested comment' do
      Given { create :comment, commentable: april_entry, comment: 'comment2' }
      When { find('.article_comment_text', text: 'comment2').find('i.fa-trash-o').click }
      When { find('i.fa-check-circle-o').click }
      Then { expect(page).to have_no_content('reply to comment 2') }
      Then { expect(page).to have_no_content('comment2') }
    end
  end
end
