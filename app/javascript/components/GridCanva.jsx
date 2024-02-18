import React from 'react';

const GridCanva = ({ state }) => {
  const current_state = JSON.parse(state)
  
  const gridStyle = {
    '--grid-size': current_state.length,
    display: 'grid',
    gridTemplateColumns: `repeat(var(--grid-size, 10), 1fr)`,
    gridTemplateRows: `repeat(var(--grid-size, 10), 1fr)`
  };

  return (
    <div className="grid" style={gridStyle}>
      {current_state.map((row, i) =>
        row.map((cell, j) => (
          <div key={`${i}-${j}`} className={`grid-cell${cell ? ' live' : ''}`}>
          </div>
        ))
      )}
    </div>
  );
};

export default GridCanva;
