// This file is our manifest of all reducers for the app.
// See also /client/app/bundles/HelloWorld/store/helloWorldStore.jsx
// A real world app will likely have many reducers and it helps to organize them in one file.
import productCatalogueReducer from './product-catalogue-reducer';
import { initialState as productCatalogueState } from './product-catalogue-reducer';

export default {
  productCatalogueStore: productCatalogueReducer,
};

export const initialStates = {
  productCatalogueState,
};
