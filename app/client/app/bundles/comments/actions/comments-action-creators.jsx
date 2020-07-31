import actionTypes from '../constants/comments-constants';
import jQuery from 'jquery';

export function showReplyForm(commentId) {
  return {
    type: actionTypes.SHOW_REPLY_FORM,
    commentId,
  };
}

export function getComments(url) {
  return dispatch =>
    jQuery.get(url).then(
      data => dispatch({ type: actionTypes.RECEIVE_COMMENTS, data })
    );
}

export function createComment(url, comment) {
  return dispatch =>
    jQuery.post(url, { comment }).then(
      data => dispatch({ type: actionTypes.RECEIVE_COMMENTS, data })
    );
}

export function deleteComment(url) {
  return dispatch =>
    jQuery.ajax(url, { method: 'DELETE' }).then(
      data => dispatch({ type: actionTypes.RECEIVE_COMMENTS, data })
    );
}
