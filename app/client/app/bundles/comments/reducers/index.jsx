import commentsReducer from './comments-reducer';
import { initialState as commentsState } from './comments-reducer';

export default {
  commentsStore: commentsReducer,
};

export const initialStates = {
  commentsState,
};
