import React, { PropTypes } from 'react';

const CatalogueItem = ({ product, perfectMatch }) => {
  const perfectMatchBlock = perfectMatch
    ? <div className="catalog_item__mood">PERFECT MATCH</div>
    : undefined;

  return (
    <div className="catalog_item">
      <a href={product.path}>
        {perfectMatchBlock}
        <img src={perfectMatch ? product.perfectImage : product.image} />
      </a>
    </div>
  );
};

CatalogueItem.propTypes = {
  product: PropTypes.object.isRequired,
  perfectMatch: PropTypes.bool.isRequired,
};

export default CatalogueItem;
