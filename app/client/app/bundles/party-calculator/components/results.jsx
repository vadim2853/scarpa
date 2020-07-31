import React, { PropTypes } from 'react';

import Product from './product';

const Results = ({ products, redBottles, whiteBottles, productsOrder, selectedEventName }) => {
  const mappedProducts = Object.values(productsOrder).map((key) => <Product {...{ ...products[key], key }}/>);

  return (
    <div className="calculator_result">
      <div className="wrapper_medium">
        <h2>WINE FOR THE {selectedEventName}</h2>
        <h3>YOU WILL NEED AROUND</h3>

        {redBottles ?
          <div className="calculator_result_num flex">
            <div className="calculator_result_amount bottle-red">{redBottles}</div>

            <div className="calculator_result_glasses flex">
              <div className="glass">4</div>
              <div>GLASSES<br /> PER BOTTLE<br/> AVERAGE</div>
            </div>
          </div>
        : null}

        {whiteBottles ?
          <div className="calculator_result_num flex">
            <div className="calculator_result_amount bottle-white">{whiteBottles}</div>

            <div className="calculator_result_glasses flex">
              <div className="glass">4</div>
              <div>GLASSES<br /> PER BOTTLE<br/> AVERAGE</div>
            </div>
          </div>
        : null}

      </div>

      <div className="wrapper_big calculator_recomend_wine">
        {productsOrder.length ? <h3>WE THINK THAT THIS WINES WOULD FIT YOU THE BEST:</h3> : null}

        <div className="flex calculator_result_wine">
          {mappedProducts}
        </div>

        <a href="/wines" className="btn red">Wine catalog</a>
      </div>
    </div>
  );
};

Results.propTypes = {
  products: PropTypes.object.isRequired,
  redBottles: PropTypes.number.isRequired,
  whiteBottles: PropTypes.number.isRequired,
  productsOrder: PropTypes.array.isRequired,
  selectedEventName: PropTypes.string.isRequired,
};

export default Results;
