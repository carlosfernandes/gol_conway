import React, { useState } from 'react';
import useBoardStore from '../stores/boardStore';

const NewBoard = ({ size }) => {
  const [gridSize, setGridSize] = useState(size);
  const [grid, setGrid] = useState(Array.from({ length: gridSize }, () => Array(gridSize).fill(false)));
  const [boardName, setBoardName] = useState('');
  const { addBoard, boards } = useBoardStore();

  const gridStyle = {
    '--grid-size': gridSize,
    display: 'grid',
    gridTemplateColumns: `repeat(var(--grid-size, 10), 1fr)`,
    gridTemplateRows: `repeat(var(--grid-size, 10), 1fr)`
  };

  const toggleCell = (row, col) => {
    const newGrid = grid.map((rowArray, rowIndex) =>
      rowIndex === row
        ? rowArray.map((cell, colIndex) => (colIndex === col ? !cell : cell))
        : rowArray
    );
    setGrid(newGrid);
  };

  const handleSizeChange = (e) => {
    const gridSize = parseInt(e.target.value);
    setGridSize(gridSize);
    setGrid(Array.from({ length: gridSize }, () => Array(gridSize).fill(false)));
  };

  const handleNameChange = (e) => {
    setBoardName(e.target.value);
  };

  const convertBooleanToIntegerArray = (arr) => {
    const integerArray = arr.map(row =>
      row.map(value => value ? 1 : 0)
    );
    return integerArray;
  }

  const handleCreate = () => {
    const integerGridArray = convertBooleanToIntegerArray(grid);
    const bodyData = { 
      board: { 
        name: boardName, 
        size: gridSize, 
        initial_state: JSON.stringify(integerGridArray) 
      }
    }

    fetch('/boards', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(bodyData),
    })
    .then(async response => {
      const data = await response.json();
      const newBoard = { id: data.id, name: data.name };
      addBoard(newBoard);
      setGrid(Array.from({ length: 10 }, () => Array(10).fill(false)));
      setBoardName('');
      setGridSize(size);
    })
    .catch(error => {
      console.error('Error:', error);
    });
  };

  return (
    <div>
      <h3>New Board</h3>
      <label htmlFor="board-name">Board Name:</label>
      <input
        type="text"
        id="board-name"
        required
        value={boardName}
        onChange={handleNameChange}
      />
      <label htmlFor="grid-size">Grid Size:</label>
      <input
        type="number"
        id="grid-size"
        value={gridSize}
        min="3"
        onChange={handleSizeChange}
      />
      <div className="grid" style={gridStyle}>
        {grid.map((row, i) =>
          row.map((cell, j) => (
            <div key={`${i}-${j}`}
              className={`grid-cell${cell ? ' live' : ''}`}
              onClick={() => toggleCell(i, j)}>
            </div>
          ))
        )}
      </div>
      <button onClick={handleCreate}>Create</button>
    </div>
  );
};

export default NewBoard;
