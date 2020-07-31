import { compose, createStore, combineReducers } from 'redux';
import reducers from '../reducers';
import { initialStates } from '../reducers';

export default props => {
  // This is how we get initial props Rails into redux.
  const { products, options, maxPrice, minPrice, isGrappaVermouth } = props;
  const { productCatalogueState } = initialStates;

  const initialState = {
    productCatalogueStore: {
      ...productCatalogueState,
      products,
      visibleProductIds: Object.keys(products),
      filterOptions: options,
      priceOptions: {
        maxPrice,
        minPrice,
      },
      isGrappaVermouth,
    },
  };

  const composedStore = compose(
    typeof window !== 'undefined' && window.devToolsExtension
    ? window.devToolsExtension()
    : f => f // eslint-disable-line id-length
  );

  const storeCreator = composedStore(createStore);
  const reducer = combineReducers(reducers);
  const store = storeCreator(reducer, initialState);

  return store;
};
