import React, { PropTypes } from 'react';

import bindAll from '../../../lib/helpers/bind-all';

export default class Comment extends React.Component {
  static propTypes = {
    showReplyForm: PropTypes.func.isRequired,
    deleteComment: PropTypes.func.isRequired,
    userPresent: PropTypes.bool.isRequired,
    comment: PropTypes.object.isRequired,
    level: PropTypes.number.isRequired,
  };

  constructor(props, context) {
    super(props, context);

    this.state = {
      confirmationVisible: false,
    };

    bindAll(this, 'toggleConfirmation');
  }

  pad(number) {
    const str = `0${number}`;

    return str.substr(str.length - 2);
  }

  showReplyForm(commentId) {
    return () => this.props.showReplyForm(commentId);
  }

  toggleConfirmation() {
    this.setState({ confirmationVisible: !this.state.confirmationVisible });
  }

  render() {
    const { comment, level, deleteComment } = this.props;

    const date = new Date(comment.createdAt);
    const formatedDate = `${this.pad(date.getDay())}.${this.pad(date.getMonth())}.${date.getFullYear()}`;

    return (
      <div className={`article__comment flex level_${level}`}>
        <div className="article__comment_img">
          <img src={comment.user.avatarUrl} />
        </div>

        <div className="article_comment_text">
          <div className="article_comment_name">{comment.user.fullName} :</div>
          <div className="article_comment_date">{formatedDate}</div>

          <div className="article_comment_massage">
            {comment.comment}
          </div>

          <div className="flex article_comment_buttons">
            {this.props.userPresent ?
              <div className="article_comment_action reply btn white x-small" onClick={this.showReplyForm(comment.id)}>
                <i className="fa fa-reply" aria-hidden="true" />
                Reply
              </div>
            : null}

            {!this.state.confirmationVisible && comment.canDestroy ?
              <div className="article_comment_action delete">
                <i className="fa fa-trash-o" aria-hidden="true" onClick={this.toggleConfirmation} />
              </div>
            : null}

            {this.state.confirmationVisible ?
              [
                <div className="article_comment_action confirm" key="accept" onClick={deleteComment}>
                  <i className="fa fa-check-circle-o" aria-hidden="true" />
                </div>,

                <div className="article_comment_action cancel" key="cancel" onClick={this.toggleConfirmation}>
                  <i className="fa fa-ban" aria-hidden="true" />
                </div>,
              ]
            : null}
          </div>
        </div>
      </div>
    );
  }

}
