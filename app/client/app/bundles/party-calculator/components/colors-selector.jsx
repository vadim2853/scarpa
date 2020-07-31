import ReactSlider from 'react-slider';
import React, { PropTypes } from 'react';

export default class ColorsSelector extends React.Component {
  static propTypes = {
    handleChange: PropTypes.func.isRequired,
    redPercenage: PropTypes.number.isRequired,
    onAfterChange: PropTypes.func.isRequired,
    whitePercenage: PropTypes.number.isRequired,
  };

  onColorsChange(key) {
    const secondKey = key === 'redPercenage' ? 'whitePercenage' : 'redPercenage';

    return (value) => this.props.handleChange({ [key]: value, [secondKey]: 100 - value });
  }

  render() {
    const { redPercenage, whitePercenage } = this.props;

    return (
      <div className="calculator_type_wine">
        <div className="wrapper">
          <h2>SELECT TYPE OF WINE</h2>
          <h3>TYPES OF WINE</h3>

          <div className="calculator_type_wine__red">
            <ReactSlider
              value={redPercenage}
              withBars={true}
              onChange={this.onColorsChange('redPercenage')}
              className="range-slider"
              onAfterChange={this.props.onAfterChange}
            >
              <div className="my-handle">{redPercenage}%</div>
            </ReactSlider>
          </div>

          <div className="calculator_type_wine__white">
            <ReactSlider
              value={whitePercenage}
              withBars={true}
              onChange={this.onColorsChange('whitePercenage')}
              className="range-slider"
              onAfterChange={this.props.onAfterChange}
            >
              <div className="my-handle">{whitePercenage}%</div>
            </ReactSlider>
          </div>
        </div>
      </div>
    );
  }
}
