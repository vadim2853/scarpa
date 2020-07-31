import React, { PropTypes } from 'react';
import FilterSelector from './../containers/filter-selector';
import bindAll from '../../../lib/helpers/bind-all';

export default class SimpleFilter extends React.Component {
  static propTypes = {
    setFilter: PropTypes.func.isRequired,
    toggleFilter: PropTypes.func.isRequired,
    isGrappaVermouth: PropTypes.bool.isRequired,
  };

  constructor(props, context) {
    super(props, context);

    bindAll(this, 'changeFilter');
  }

  changeFilter(filterType) {
    return event => this.props.setFilter(filterType, event.val);
  }

  render() {
    const isGrappaVermouth = this.props.isGrappaVermouth;

    return (
      <div className="text_center simple_filter">
        <h2>WHAT KIND OF WINE WOULD YOU LIKE?</h2>
        <div className="search wrapper_big">
          <div className="flex flex_search">
            <div className="width_33 width_100_s">
              <FilterSelector
                onChange={this.changeFilter('color')}
                filterOption="color"
                placeholder="WINE COLOR"
              />
            </div>
            <div className="width_33 width_100_s">
              <FilterSelector
                onChange={this.changeFilter('age')}
                filterOption="age"
                placeholder="WINE age"
              />
            </div>
            <div className="width_33 width_100_s">
              <FilterSelector
                onChange={this.changeFilter('food')}
                filterOption="food"
                placeholder="today's dinner"
              />
            </div>
          </div>

          {!isGrappaVermouth ? (
              <div className="search_open" onClick={this.props.toggleFilter}>
                <span>Advanced search</span>
              </div>
            ) : null
          }
        </div>
      </div>
    );
  }
}
