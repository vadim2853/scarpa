import React, { PropTypes } from 'react';

const ProductsRow = ({ products }) => (
  <div className={`item_${products.length} category products-row`}>
    {products}
  </div>
);

ProductsRow.propTypes = {
  products: PropTypes.array.isRequired,
};

export default ProductsRow;
