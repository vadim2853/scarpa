import mirrorCreator from 'mirror-creator';

// jscs:disable requireCamelCaseOrUpperCaseIdentifiers
export const productWeightsTable = {
  taste: 4,
  location: 3,
  mood: 2,
  music: 2,
  time_of_the_day: 1,
  season: 1,
};

// jscs:enable requireCamelCaseOrUpperCaseIdentifiers

const actionTypes = mirrorCreator([
  'TOGGLE_FILTER',
  'SET_FILTERS',
  'SET_FILTER',
]);

export default actionTypes;
