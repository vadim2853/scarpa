import actionTypes, { productWeightsTable } from '../constants/product-catalogue-constants';
import trimOptions from '../../../lib/helpers/trim-options';

export const initialState = {
  products: {},
  advancedFilterVisible: false,
  selectedOptions: {},
};

const ensureNumber = (number) => number || 0;

const productHasProperty = (products, newSelectedOptions, selectedOption) =>
  (id) => {
    const array = Object.values(products[id][selectedOption]).reduce((a, b) => a.concat(b), []);
    return array.indexOf(newSelectedOptions[selectedOption]) >= 0;
  };

const costsLessThen = (products, newSelectedOptions, selectedOption) =>
  (id) => products[id].price <= newSelectedOptions[selectedOption];

const costsMoreThen = (products, newSelectedOptions, selectedOption) =>
  (id) => products[id].price >= newSelectedOptions[selectedOption];

const selectProductIds = (products, newSelectedOptions) => {
  let newProductIds = Object.keys(products);

  for (const selectedOption of Object.keys(newSelectedOptions)) {
    let filterFunction;

    if (selectedOption === 'currentMaxPrice') {
      filterFunction = costsLessThen;
    } else if (selectedOption === 'currentMinPrice') {
      filterFunction = costsMoreThen;
    } else {
      filterFunction = productHasProperty;
    }

    newProductIds = newProductIds.filter(filterFunction(products, newSelectedOptions, selectedOption));
  }

  return newProductIds;
};

const orderProductIds = (products, selectedProductIds, selectedOrders) => {
  const newProductIds = selectedProductIds.slice(0);
  const newProductWeights = {};

  for (const orderType of Object.keys(selectedOrders)) {
    for (const id of selectedProductIds) {
      if (products[id][orderType].indexOf(selectedOrders[orderType]) >= 0) {
        newProductWeights[id] = ensureNumber(newProductWeights[id]) + productWeightsTable[orderType];
      }
    }
  }

  newProductIds.sort((a, b) => ensureNumber(newProductWeights[b]) - ensureNumber(newProductWeights[a]));

  return newProductIds;
};

export default function productCatalogueReducer(state = initialState, action) {
  const { type, filterType, filterValue, filterValues, orderValues } = action;

  switch (type) {
    case actionTypes.TOGGLE_FILTER: {
      const newState = {
        ...state,
        advancedFilterVisible: !state.advancedFilterVisible,
      };

      if (state.advancedFilterVisible) {
        const { age, color, food } = newState.selectedOptions;

        newState.selectedOptions = trimOptions({ age, color, food });
        newState.visibleProductIds = selectProductIds(newState.products, newState.selectedOptions);
      }

      return newState;
    }

    case actionTypes.SET_FILTER: {
      const selectedOptions = trimOptions({ ...state.selectedOptions, [filterType]: filterValue });
      const visibleProductIds = selectProductIds(state.products, selectedOptions);

      return { ...state, selectedOptions, visibleProductIds };
    }

    case actionTypes.SET_FILTERS: {
      const selectedProductIds = selectProductIds(state.products, filterValues);
      const visibleProductIds = orderProductIds(state.products, selectedProductIds, orderValues);
      const selectedOptions = filterValues;

      return { ...state, selectedOptions, visibleProductIds };
    }

    default:
      return state;
  }
}
