import pluralize from 'pluralize';
import { connect } from 'react-redux';
import React, { PropTypes } from 'react';
import { bindActionCreators } from 'redux';

import Comment from '../components/comment';
import PostForm from '../components/post-form';
import * as commentsActionCreators from '../actions/comments-action-creators';

function select(state) {
  return { commentsStore: state.commentsStore };
}

class CommentsContainer extends React.Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    commentsStore: PropTypes.object.isRequired,
  };

  componentDidMount() {
    this.props.dispatch(
      commentsActionCreators.getComments(
        this.props.commentsStore.rootApiEndpoint
      )
    );
  }

  subComment(commentId, level, visibleReplyForm, showReplyForm, postComment, deleteComment, userPresent) {
    const url = this.props.commentsStore.elementApiEndpoint.replace('comment_id', commentId);
    const comment = this.props.commentsStore.comments[commentId];
    const nextLevel = level < 3 ? level + 1 : level;

    const deleteEndpoint = comment.commentableType === 'Spree::Comment'
      ? this.props.commentsStore.elementApiEndpoint.replace('comment_id', comment.commentableId)
      : this.props.commentsStore.rootApiEndpoint;

    const form = visibleReplyForm === commentId
      ? <PostForm url={url} key="subform" rows="5" postComment={postComment} level={level} />
      : null;

    const deleteThisComment = () => deleteComment(`${deleteEndpoint}/${comment.id}`);

    return [
      <Comment
        { ...{ comment, level, showReplyForm, userPresent, key: commentId, deleteComment: deleteThisComment } }
      />,

      form,

      (this.props.commentsStore.relations[commentId] || []).map(
        subCommentId => this.subComment(
          subCommentId,
          nextLevel,
          visibleReplyForm,
          showReplyForm,
          postComment,
          deleteComment,
          userPresent
        )
      ),
    ];
  }

  render() {
    const actions = bindActionCreators(commentsActionCreators, this.props.dispatch);

    const { showReplyForm, createComment, deleteComment } = actions;
    const { rootApiEndpoint, rootComments, count, userPresent, visibleReplyForm } = this.props.commentsStore;

    const leaveCommentH4 = <h4 key="h4">LEAVE COMMENT :</h4>;

    const form = userPresent
      ? [
        leaveCommentH4,
        <PostForm url={rootApiEndpoint} key="form" rows="10" postComment={createComment} level={1} />,
      ]
      : [
        leaveCommentH4,
        <textarea
          key="text"
          rows="10"
          disabled={true}
          className="disable"
          placeholder="I would love to say"
        />,
        <div
          key="link"
          className="btn red x-small"
          onClick={openLogin} // eslint-disable-line no-undef
        >
          Login to comment
        </div>,
        <div className="clear"></div>,
      ];

    const postComment = (url, comment) => createComment(url, comment).then(() => showReplyForm(0));

    return (
      <div className="article__comments">
        <div className="comments_textarea_btn">
          {form}
        </div>

        {count ?
          <div className="article__already_comments comments_textarea_btn">
            <h4>{count} {pluralize('COMMENT', count)} :</h4>

            {rootComments.map(
              commentId => this.subComment(
                commentId,
                1,
                visibleReplyForm,
                showReplyForm,
                postComment,
                deleteComment,
                userPresent
              )
            )}
          </div>
        : null}
      </div>
    );
  }
}

// Don't forget to actually use connect!
// Note that we don't export HelloWorld, but the redux "connected" version of it.
// See https://github.com/reactjs/react-redux/blob/master/docs/api.md#examples
export default connect(select)(CommentsContainer);
