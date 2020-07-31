import { compose, createStore, combineReducers, applyMiddleware } from 'redux';
import { initialStates } from '../reducers';
import reducers from '../reducers';
import thunkMiddleware from 'redux-thunk';

export default props => {
  // This is how we get initial props Rails into redux.
  const { rootApiEndpoint, elementApiEndpoint, userPresent } = props;
  const { commentsState } = initialStates;

  const initialState = {
    commentsStore: {
      ...commentsState,
      userPresent,
      rootApiEndpoint,
      elementApiEndpoint,
    },
  };

  const composedStore = compose(
    applyMiddleware(thunkMiddleware),
    typeof window !== 'undefined' && window.devToolsExtension ? window.devToolsExtension() : func => func
  );

  const storeCreator = composedStore(createStore);
  const reducer = combineReducers(reducers);
  const store = storeCreator(reducer, initialState);

  return store;
};
