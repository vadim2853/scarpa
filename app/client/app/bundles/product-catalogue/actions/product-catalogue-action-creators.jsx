import actionTypes from '../constants/product-catalogue-constants';

export function toggleFilter() {
  return {
    type: actionTypes.TOGGLE_FILTER,
  };
}

export function setFilter(filterType, filterValue) {
  return {
    type: actionTypes.SET_FILTER,
    filterValue,
    filterType,
  };
}

export function setFilters(filterValues, orderValues) {
  return {
    type: actionTypes.SET_FILTERS,
    filterValues,
    orderValues,
  };
}
