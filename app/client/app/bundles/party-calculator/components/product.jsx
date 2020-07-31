import React, { PropTypes } from 'react';

const Product = ({ name, path, image }) => (
  <a href={path} className="calculator_result_wine__block">
    <div className="calculator_result_wine__img">
      <img src={image} />
    </div>

    <div className="calculator_result_wine__name">{name}</div>
  </a>
);

Product.propTypes = {
  name: PropTypes.string.isRequired,
  path: PropTypes.string.isRequired,
  image: PropTypes.string.isRequired,
};

export default Product;
