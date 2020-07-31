import React, { PropTypes } from 'react';
import ReactSlider from 'react-slider';
import FilterSelector from './../containers/filter-selector';
import bindAll from '../../../lib/helpers/bind-all';
import trimOptions from '../../../lib/helpers/trim-options';

export default class AdvancedFilter extends React.Component {
  static propTypes = {
    setFilters: PropTypes.func.isRequired,
    toggleFilter: PropTypes.func.isRequired,
    priceOptions: PropTypes.object.isRequired,
    selectedOptions: PropTypes.object.isRequired,
  };

  shouldComponentUpdate(nextProps, nextState) {
    if (this.filterChanged(nextState, 'currentMinPrice')) return true;
    if (this.filterChanged(nextState, 'currentMaxPrice')) return true;

    return false;
  }

  constructor(props, context) {
    super(props, context);

    bindAll(this, 'changeFilter', 'changeOrder', 'setFilters', 'priceChange', 'filterChanged');

    this.state = {
      filters: {
        ...this.props.selectedOptions,
        currentMaxPrice: this.props.priceOptions.maxPrice,
        currentMinPrice: this.props.priceOptions.minPrice,
      },
      orders: {},
    };
  }

  changeFilter(filterType) {
    return event => this.setState({ filters: { ...this.state.filters, [filterType]: event.val } });
  }

  changeOrder(orderType) {
    return event => this.setState({ orders: { ...this.state.orders, [orderType]: event.val } });
  }

  setFilters() {
    this.props.setFilters(
      trimOptions({ ...this.state.filters }),
      trimOptions({ ...this.state.orders })
    );

    scrollToCatalog(); // eslint-disable-line
  }

  priceChange([min, max]) {
    this.setState({
      filters: {
        ...this.state.filters,
        currentMinPrice: min,
        currentMaxPrice: max,
      },
    });
  }

  filterChanged(nextState, prop) {
    return this.state.filters[prop] !== nextState.filters[prop];
  }

  render() {
    const { maxPrice, minPrice } = this.props.priceOptions;

    const windowWidth = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;

    const minDistance = (120 * (maxPrice - minPrice)) / windowWidth;

    return (
      <div className="text_center advanced_filter">
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
          <div className="search_open" onClick={this.props.toggleFilter}>
            <span>Advanced search</span>
          </div>
          <div className="filter_more">
            <div className="flex flex_search mar_top_50">
              <div className="width_50 width_100_s">
                <FilterSelector
                  onChange={this.changeOrder('mood')}
                  filterOption="mood"
                  placeholder="current mood"
                />
              </div>
              <div className="width_50 width_100_s">
                <FilterSelector
                  onChange={this.changeOrder('music')}
                  filterOption="music"
                  placeholder="Music"
                />
              </div>
            </div>
            <div className="flex flex_search">
              <div className="width_33 width_100_s">
                <FilterSelector
                  onChange={this.changeOrder('time_of_the_day')}
                  filterOption="time_of_the_day"
                  placeholder="time of the day"
                />
              </div>
              <div className="width_33 width_100_s">
                <FilterSelector
                  onChange={this.changeOrder('season')}
                  filterOption="season"
                  placeholder="season"
                />
              </div>
              <div className="width_33 width_100_s">
                <FilterSelector
                  onChange={this.changeOrder('location')}
                  filterOption="location"
                  placeholder="location"
                />
              </div>
            </div>
            <div className="flex justify-center flex_search">
              <div className="width_50 width_100_s">
                <FilterSelector
                  onChange={this.changeOrder('taste')}
                  filterOption="taste"
                  placeholder="TASTE PREFERENCES"
                />
              </div>
            </div>
            <div className="range-slider_name">PRICE RANGE PER BOTTLE</div>
            <div className="range-slider_bg">
              <ReactSlider
                className="range-slider"
                defaultValue={[minPrice, maxPrice]}
                min={minPrice}
                max={maxPrice}
                onChange={this.priceChange}
                withBars={true}
                minDistance={minDistance}
                pearling={true}
              >
                <div className="my-handle">{this.state.filters.currentMinPrice.toFixed(0)}<br />euro</div>
                <div className="my-handle">{this.state.filters.currentMaxPrice.toFixed(0)}<br />euro</div>
              </ReactSlider>
            </div>
            <button type="submit" className="btn red" onClick={this.setFilters}>filter</button>
          </div>
        </div>
      </div>
    );
  }
}
