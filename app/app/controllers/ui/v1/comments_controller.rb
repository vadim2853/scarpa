class Ui::V1::CommentsController < Ui::BaseController
  before_action :require_authentication, except: :index

  def index
    respond_with_interaction Ui::CommentsLoadingInteraction, root_commentable_id: root_commentable_id
  end

  def create
    comment = Spree::Comment.new(comment_params)

    if comment.save
      respond_with_interaction Ui::CommentsLoadingInteraction, root_commentable_id: root_commentable_id
    else
      render json: { errors: comment.errors.messages }, status: 422
    end
  end

  def destroy
    comment = Spree::Comment.find(params[:id])

    authorize! :destroy, comment

    if comment.destroy
      respond_with_interaction Ui::CommentsLoadingInteraction, root_commentable_id: root_commentable_id
    else
      render json: { errors: comment.errors.messages }, status: 500
    end
  end

  private

  def comment_params
    params
      .permit(:comment, :commentable_type)
      .merge(
        user: spree_current_user,
        commentable_id: commentable_id,
        root_commentable_id: root_commentable_id
      )
  end

  def commentable_id
    determine_id(:id)
  end

  def root_commentable_id
    determine_id(:root_commentable_id)
  end

  def determine_id(attribute)
    @comment ||= Spree::Comment.find(params[:comment_id]) if params[:commentable_type] == Spree::Comment::COMMENT_TYPE

    @comment && @comment[attribute] || params[:blog_id] || params[:product_id]
  end
end
