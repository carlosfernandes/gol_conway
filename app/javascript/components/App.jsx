// app/javascript/application.jsx

import React from 'react';
import ReactDOM from 'react-dom';
import BoardList from './BoardList.jsx';
import NewBoard from './NewBoard.jsx';


const App = () => {
  const boardSize = 10;
  return (
      <div>
        <header className='main-header'>
          <h1>Conway's Game Of Life</h1>
        </header>
          <NewBoard size={boardSize} />
          <BoardList />
      </div>
  );
};

ReactDOM.render(<App />, document.getElementById('root'));
