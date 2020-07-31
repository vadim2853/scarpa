import React, { PropTypes } from 'react';
import Select2 from 'react-select2-wrapper';
import { connect } from 'react-redux';
import select from '../../../lib/helpers/select';

const FilterSelector = ({ onChange, placeholder, filterOption, productCatalogueStore }) => (
  <Select2
    onChange={onChange}
    className="selecter"
    defaultValue={productCatalogueStore.selectedOptions[filterOption] || ''}
    data={[
      { text: placeholder, id: '' },
      ...productCatalogueStore.filterOptions[filterOption],
    ]}
    options={{
      minimumResultsForSearch: -1,
    }}
  />
);

FilterSelector.propTypes = {
  onChange: PropTypes.func.isRequired,
  placeholder: PropTypes.string.isRequired,
  filterOption: PropTypes.string.isRequired,
};

export default connect(select)(FilterSelector);
