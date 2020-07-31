require 'rails_helper'

describe Ui::CommentsLoadingInteraction do
  Given(:blog) { create :blog_entry }
  Given(:interaction) { described_class.new(user: user, params: {}, options: { root_commentable_id: blog.id }) }

  describe '#as_json' do
    Given!(:comment_1) { create :comment, user: user, commentable: blog }
    Given!(:comment_2) { create :comment, user: user, commentable: blog }
    Given!(:comment_3) { create :comment, user: user, commentable: comment_2 }

    Given(:user_name) { { first_name: 'Vova', last_name: 'Pupkin' } }
    Given(:full_name) { 'Vova Pupkin' }
    Given(:blog_type) { 'Spree::BlogEntry' }
    Given(:avatar_url) { '/avatars/small/missing.png' }
    Given(:comment_text) { 'MyText' }

    Given(:expected) do
      {
        comments: {
          comment_3.id => {
            id: comment_3.id,
            comment: comment_text,
            canDestroy: can_destroy,
            createdAt: comment_2.created_at.to_formatted_s(:rfc822),
            commentableId: comment_2.id,
            commentableType: 'Spree::Comment',
            user: {
              fullName: full_name,
              avatarUrl: avatar_url
            }
          },
          comment_2.id => {
            id: comment_2.id,
            comment: comment_text,
            canDestroy: can_destroy,
            createdAt: comment_1.created_at.to_formatted_s(:rfc822),
            commentableId: blog.id,
            commentableType: blog_type,
            user: {
              fullName: full_name,
              avatarUrl: avatar_url
            }
          },
          comment_1.id => {
            id: comment_1.id,
            comment: comment_text,
            canDestroy: can_destroy,
            createdAt: comment_1.created_at.to_formatted_s(:rfc822),
            commentableId: blog.id,
            commentableType: blog_type,
            user: {
              fullName: full_name,
              avatarUrl: avatar_url
            }
          }
        },
        rootComments: [comment_2.id, comment_1.id],
        count: 3,
        relations: {
          comment_2.id => [comment_3.id]
        }
      }
    end

    context 'admin' do
      Given(:user) { create :admin_user, user_name }
      Given(:can_destroy) { true }

      Then { expect(interaction.as_json).to eq(expected) }
    end

    context 'blogger' do
      Given(:user) { create :blog_user, user_name }
      Given(:can_destroy) { false }

      Then { expect(interaction.as_json).to eq(expected) }
    end
  end
end
