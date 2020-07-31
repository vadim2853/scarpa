import Select2 from 'react-select2-wrapper';
import ReactSlider from 'react-slider';
import React, { PropTypes } from 'react';

import bindAll from '../../../lib/helpers/bind-all';

import Results from '../components/results';
import ColorsSelector from '../components/colors-selector';

const GLASSES = 4;

export default class PartyCalculator extends React.Component {
  static propTypes = {
    months: PropTypes.object.isRequired,
    events: PropTypes.object.isRequired,
    dayIcon: PropTypes.string.isRequired,
    products: PropTypes.object.isRequired,
    nightIcon: PropTypes.string.isRequired,
    backgrounds: PropTypes.object.isRequired,
  };

  constructor(props, context) {
    super(props, context);

    const dayIcon = {
      backgroundImage: this.url(this.props.dayIcon),
      backgroundSize: '70%',
    };

    const nightIcon = {
      backgroundImage: this.url(this.props.nightIcon),
      backgroundSize: '46%',
    };

    this.state = {
      dayIcon,
      nightIcon,
      guests: 10,
      monthId: (new Date()).getMonth() + 1,
      eventId: Object.keys(this.props.events)[0],
      maxGuests: 50,
      eventTime: [17, 20],
      redBottles: 0,
      whiteBottles: 0,
      eventMaxTime: 24,
      redPercenage: 50,
      backgroundIds: this.prepareBackgroundsIds(),
      eventsOptions: this.prepareEventsOptions(),
      productsOrder: [],
      whitePercenage: 50,
    };

    bindAll(
      this,
      'addMoreTime',
      'changeEvent',
      'countBottles',
      'addMoreGuests',
      'setStateParam',
      'allowedByColor',
      'calculateResult',
      'eventBackground',
      'handleColorChange',
      'selectProductsOrder',
      'prepareEventsOptions',
      'getSelectedEventName',
      'prepareBackgroundsIds',
    );
  }

  componentDidMount() {
    this.calculateResult();
  }

  prepareBackgroundsIds() {
    const result = {};

    for (const id of Object.keys(this.props.backgrounds)) {
      const bg = this.props.backgrounds[id];

      result[bg.eventId] = result[bg.eventId] || {};
      result[bg.eventId][bg.monthId] = result[bg.eventId][bg.monthId] || [];

      result[bg.eventId][bg.monthId].push(id);

      if (bg.default) result[bg.eventId].default = id;
    }

    for (const eventId of Object.keys(result)) {
      for (const monthId of Object.keys(result[eventId])) {
        if (monthId !== 'default') {
          result[eventId][monthId] = result[eventId][monthId].sort(
            (leftId, rightId) => this.props.backgrounds[leftId].guests - this.props.backgrounds[rightId].guests
          );
        }
      }
    }

    return result;
  }

  prepareEventsOptions() {
    const eventsOptions = [];

    for (const id of Object.keys(this.props.events)) {
      eventsOptions.push({ text: this.props.events[id].name, id });
    }

    return eventsOptions;
  }

  handleColorChange(obj) {
    this.setState({ ...this.state, ...obj });
  }

  setStateParam(param) {
    return (value) => this.setState({ ...this.state, [param]: value });
  }

  addMoreGuests() {
    const step = this.state.maxGuests < 100 ? 50 : 100;

    this.setState({ ...this.state, maxGuests: this.state.maxGuests + step });
  }

  addMoreTime() {
    this.setState({ ...this.state, eventMaxTime: this.state.eventMaxTime + 24 });
  }

  changeEvent(action) {
    this.setState({ ...this.state, eventId: action.val });
    this.calculateResult();
  }

  url(path) {
    return `url(${path})`;
  }

  isItDay(hour) {
    const hourOfDay = hour % 24;

    return hourOfDay % 24 >= 6 && hourOfDay < 18;
  }

  calculateResult() {
    const { eventId, eventTime } = this.state;

    const hours = eventTime[1] - eventTime[0];

    const redEventRatio = this.props.events[eventId].redRate;
    const whiteEventRatio = this.props.events[eventId].whiteRate;

    const redPercenage = this.state.redPercenage / 100;
    const whitePercenage = this.state.whitePercenage / 100;

    let redBottles;
    let whiteBottles;

    if (hours <= 5) {
      redBottles = Math.ceil(this.countBottles(redEventRatio, redPercenage, hours, 1));
      whiteBottles = Math.ceil(this.countBottles(whiteEventRatio, whitePercenage, hours, 1));
    } else {
      const restHours = hours - 5;

      redBottles = Math.ceil(
        this.countBottles(redEventRatio, redPercenage, 5, 1) +
        this.countBottles(redEventRatio, redPercenage, restHours, 2)
      );

      whiteBottles = Math.ceil(
        this.countBottles(whiteEventRatio, whitePercenage, 5, 1) +
        this.countBottles(whiteEventRatio, whitePercenage, restHours, 2)
      );
    }

    const productsOrder = this.selectProductsOrder();

    this.setState({ ...this.state, redBottles, whiteBottles, productsOrder });
  }

  selectProductsOrder() {
    const eventProductsIds = this.props.events[this.state.eventId].products;
    const monthProductsIds = this.props.months[this.state.monthId].products;

    const result = eventProductsIds.filter(id => monthProductsIds.indexOf(id) >= 0 && this.allowedByColor(id));

    if (result.length >= 5) return result.slice(0, 5);

    for (const id of eventProductsIds) {
      if (result.length >= 5) break;
      if (result.indexOf(id) === -1 && this.allowedByColor(id)) result.push(id);
    }

    for (const id of monthProductsIds) {
      if (result.length >= 5) break;
      if (result.indexOf(id) === -1 && this.allowedByColor(id)) result.push(id);
    }

    return result;
  }

  allowedByColor(productId) {
    if (this.state.redPercenage !== 0 && this.state.whitePercenage !== 0) return true;

    if (this.state.redPercenage !== 0 && this.props.products[productId].color === 'red') return true;

    return this.state.whitePercenage !== 0 && this.props.products[productId].color === 'white';
  }

  countBottles(eventRatio, colorPercentage, hours, hoursRatio) {
    const { guests, monthId } = this.state;

    const seasonRatio = this.props.months[monthId].rate;

    return (seasonRatio * eventRatio * colorPercentage * guests * hours) / (hoursRatio * GLASSES);
  }

  eventBackground() {
    const { backgroundIds, eventId, monthId, guests } = this.state;

    let matchedBackground;

    for (const id of backgroundIds[eventId][monthId] || []) {
      const background = this.props.backgrounds[id];

      if (background.guests <= guests) matchedBackground = background;
    }

    return matchedBackground || this.props.backgrounds[backgroundIds[eventId].default];
  }

  getSelectedEventName() {
    const eventId = this.state.eventId;

    return eventId && this.props.events ? this.props.events[eventId].name : 'PARTY';
  }

  render() {
    const month = this.props.months[this.state.monthId];
    const backgroundImage = this.url(this.eventBackground().imagePath);
    const leftHandleStyle = this.isItDay(this.state.eventTime[0]) ? this.state.dayIcon : this.state.nightIcon;
    const rightHandleStyle = this.isItDay(this.state.eventTime[1]) ? this.state.dayIcon : this.state.nightIcon;
    const selectedEventName = this.getSelectedEventName();

    return (
      <section className="calculator">
        <div className="calculator_buying" style={{ backgroundImage }}>
          <div className="red_bg"></div>

          <div className="wrapper_big">
            <h2>WINE BUYING CALCULATOR</h2>
            <h3>TYPE OF THE EVENT</h3>

            <Select2
              data={this.state.eventsOptions}
              options={{ placeholder: 'search by tags', minimumResultsForSearch: -1 }}
              onChange={this.changeEvent}
              className="party_selecter"
              defaultValue={this.state.eventId}
            />

            <h3>NUMBER OF GUESTS</h3>

            <div className="calculator_range_guests">
              <ReactSlider
                min={1}
                max={this.state.maxGuests}
                value={this.state.guests}
                withBars={true}
                onChange={this.setStateParam('guests')}
                className="range-slider"
                onAfterChange={this.calculateResult}
              >
                <div className="my-handle">{this.state.guests}</div>
              </ReactSlider>
              {this.state.guests === this.state.maxGuests
              ? <span onClick={this.addMoreGuests} className="calculator__add_more"></span>
              : <span className="calculator__add_more disable"></span>}
            </div>

            <h3>THE PARTY WILL TAKE PLACE</h3>

            <div className="calculator_range_place">
              <ReactSlider
                min={1}
                max={this.state.eventMaxTime}
                value={this.state.eventTime}
                withBars={true}
                pearling={true}
                onChange={this.setStateParam('eventTime')}
                className="range-slider"
                minDistance={1}
                onAfterChange={this.calculateResult}
                handleOddStyle={rightHandleStyle}
                handleEvenStyle={leftHandleStyle}
              >
                <div className="my-handle sun">{this.state.eventTime[0] % 24}</div>
                <div className="my-handle moon">{this.state.eventTime[1] % 24}</div>
              </ReactSlider>
              {this.state.eventTime[1] === 24 && this.state.eventMaxTime === 24
              ? <span onClick={this.addMoreTime} className="calculator__add_more"></span>
              : <span className="calculator__add_more disable"></span>}
            </div>

            <h3>SELECT THE SEASON</h3>

            <div className="calculator_range_season">
              <ReactSlider
                min={1}
                max={12}
                value={this.state.monthId}
                withBars={true}
                onChange={this.setStateParam('monthId')}
                className="range-slider"
                onAfterChange={this.calculateResult}
                handleEvenStyle={{ backgroundImage: this.url(month.icon) }}
              >
                <div className="my-handle">{month.name}</div>
              </ReactSlider>
            </div>
          </div>
        </div>

        <ColorsSelector
          handleChange={this.handleColorChange}
          redPercenage={this.state.redPercenage}
          onAfterChange={this.calculateResult}
          whitePercenage={this.state.whitePercenage}
        />

        <Results
          products={this.props.products}
          redBottles={this.state.redBottles}
          whiteBottles={this.state.whiteBottles}
          productsOrder={this.state.productsOrder}
          selectedEventName={selectedEventName}
        />
      </section>
    );
  }
}
