module Ui
  class CommentsLoadingInteraction < ::BaseInteraction
    def init
      @comments = Spree::Comment.where(root_commentable_id: options[:root_commentable_id]).includes(:user)
    end

    def as_json(*)
      result = {
        comments: {},
        rootComments: [],
        count: @comments.count,
        relations: Hash.new { |h, k| h[k] = [] }
      }

      ability = Ability.new(user)

      @comments.each do |comment|
        result[:comments][comment.id] = serialize(comment, ability.can?(:destroy, comment))

        if comment.commentable_type == Spree::Comment::COMMENT_TYPE
          result[:relations][comment.commentable_id]
        else
          result[:rootComments]
        end << comment.id
      end

      result
    end

    private

    def serialize(c, can_destroy)
      {
        id: c.id,
        comment: c.comment,
        canDestroy: can_destroy,
        createdAt: c.created_at.to_formatted_s(:rfc822),
        commentableId: c.commentable_id,
        commentableType: c.commentable_type,
        user: {
          fullName: c.user.full_name,
          avatarUrl: c.user.avatar_url
        }
      }
    end
  end
end
