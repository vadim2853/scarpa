import React, { PropTypes } from 'react';
import SimpleFilter from '../components/simple-filter';
import AdvancedFilter from '../components/advanced-filter';
import ProductsRow from '../components/products-row';
import CatalogueItem from '../components/catalogue-item';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import * as productCatalogueActionCreators from '../actions/product-catalogue-action-creators';
import bindAll from '../../../lib/helpers/bind-all';
import select from '../../../lib/helpers/select';
import ReactCSSTransitionGroup from 'react-addons-css-transition-group';

class ProductCatalogue extends React.Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    productCatalogueStore: PropTypes.object.isRequired,
  };

  constructor(props, context) {
    super(props, context);

    bindAll(this, 'groupForRows');
  }

  groupForRows(array) {
    const clone = array.slice(0);
    const result = [];

    while (clone.length > 0) {
      result.push(clone.splice(0, clone.length > 4 ? 5 : 3));
    }

    return result;
  }

  render() {
    const { dispatch, productCatalogueStore } = this.props;

    const actions = bindActionCreators(productCatalogueActionCreators, dispatch);
    const groupedVisibleIds = this.groupForRows(productCatalogueStore.visibleProductIds);
    const productRows = groupedVisibleIds.map(productIds => {
      const products = productIds.map(key => {
        const product = productCatalogueStore.products[key];
        const perfectMatch = !!productCatalogueStore.selectedOptions.food &&
          productIds.indexOf(key) === 0;

        return <CatalogueItem {...{ product, key, perfectMatch }}/>;
      });

      return <ProductsRow {...{ products, key: productIds }}/>;
    });

    const { toggleFilter, setFilter, setFilters } = actions;
    const { advancedFilterVisible, selectedOptions, priceOptions, isGrappaVermouth } = productCatalogueStore;

    const advancedFilter = advancedFilterVisible
      ? [<AdvancedFilter {...{ toggleFilter, selectedOptions, setFilters, priceOptions, key: 'adv' }}/>]
      : [];

    const simpleFilter = !advancedFilterVisible
      ? [<SimpleFilter {...{ toggleFilter, setFilter, key: 'smpl', isGrappaVermouth }}/>]
      : [];

    return (
      <section>
        <div className="filters">
          <ReactCSSTransitionGroup
            transitionName="simple_filter"
            transitionEnterTimeout={600}
            transitionLeaveTimeout={600}
          >
            {simpleFilter}
          </ReactCSSTransitionGroup>

          <ReactCSSTransitionGroup
            transitionName="advanced_filter"
            transitionEnterTimeout={600}
            transitionLeaveTimeout={600}
          >
            {advancedFilter}
          </ReactCSSTransitionGroup>
        </div>

        <div className="catalog">
          {productRows}
        </div>
      </section>
    );
  }
}

// Don't forget to actually use connect!
// Note that we don't export HelloWorld, but the redux "connected" version of it.
// See https://github.com/reactjs/react-redux/blob/master/docs/api.md#examples
export default connect(select)(ProductCatalogue);
