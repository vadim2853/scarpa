import actionTypes from '../constants/comments-constants';

export const initialState = {
  visibleReplyForm: 0,
  rootComments: [],
  comments: {},
  count: 0,
};

export default function commentsReducer(state = initialState, action) {
  const { type, data, commentId } = action;

  switch (type) {
    case actionTypes.SHOW_REPLY_FORM: {
      return {
        ...state,
        visibleReplyForm: commentId,
      };
    }

    case actionTypes.RECEIVE_COMMENTS: {
      const { comments, rootComments, count, relations } = data;

      return {
        ...state,
        count,
        comments,
        relations,
        rootComments,
      };
    }

    default:
      return state;
  }
}
