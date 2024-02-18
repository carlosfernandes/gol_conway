// app/javascript/components/BoardList.jsx

import React, { Button, useState, useEffect } from 'react';
import GridCanva from './GridCanva';
import useBoardStore from '../stores/boardStore';

const BoardList = ({}) => {
  const [selectedBoard, setSelectedBoard] = useState(null);
  const [generation, setGeneration] = useState(null);
  const { addBoard, boards } = useBoardStore();
  const [generationsAway, setGenerationsAway] = useState(1)
  const [finalGenerationAttempts, setFinalGenerationAttempts] = useState(1)

  useEffect(() => {
    fetchBoards();
  }, []);
  
  const fetchBoards = async () => {
    try {
      const response = await fetch('/boards');
      if (!response.ok) {
        throw new Error('Failed to fetch data');
      }
      const data = await response.json();
      data.boards.map(board => {
        addBoard(board);
      });
    } catch (error) {
      console.error(error)
    }
  };

  const getNextGeneration = async (boardId, currentGeneration=0) => {
    try {
      const nextGeneration = currentGeneration + 1;
      const response = await fetch(`/boards/${boardId}/generations/${nextGeneration}`);
      const data = await response.json();
      setGeneration(data.generation);
      setSelectedBoard(boardId);
    } catch (error) {
      console.error('Error fetching first generation:', error);
    }
  };

  const getGenerationsAway = async (boardId, stepsAway) => {
    try {
      const awayGeneration = parseInt(stepsAway) + 1;
      const response = await fetch(`/boards/${boardId}/generations/${awayGeneration}?generations_away=${stepsAway}`);
      const data = await response.json();
      setGeneration(data.generation);
      setSelectedBoard(boardId);
    } catch (error) {
      console.error('Error fetching first generation:', error);
    }
  };

  const handleGenerationsAwayChange = (e) => {
    setGenerationsAway(e.target.value);
    console.log(generationsAway)
  };

  const handleFinalGenerationAttemptsChange = (e) => {
    setFinalGenerationAttempts(e.target.value);
  };

  return (
    <div>
      <h2>Boards List</h2>
      <ul className='boardList'>
        {boards.map((board) => (
          <li key={board.id} onClick={() => getNextGeneration(board.id)}>
            {board.id} {board.name}
          </li>
        ))}
      </ul>
      {
        generation && (
          <div key={generation.id}>
            <h3>
                Board #{selectedBoard} - Generation {generation.order} 
                {generation.final ? '(Final)' : ''}
            </h3>
            {!generation.final && (
            <>
              <div>
              <label>
                Generations Away from Start
              </label>
              <input
                type="number"
                id="generations-away"
                value={generationsAway}
                min="1"
                onChange={handleGenerationsAwayChange}
              />
              <button onClick={() => {getGenerationsAway(selectedBoard, generationsAway)}}>
                Get Generation
              </button>
              </div>

              <div>
              <label>
                Define the max attempts
              </label>
              <input
                type="number"
                id="max-attempts"
                value={finalGenerationAttempts}
                min="1"
                onChange={handleFinalGenerationAttemptsChange}
              />
              <button onClick={() => {getGenerationsAway(selectedBoard, finalGenerationAttempts)}}>
                Final Generation
              </button>
              </div>

              <div>
                <button onClick={() => {getNextGeneration(selectedBoard, generation.order)}}>
                  Next Generation
                </button>
              </div>
            </>
            )}

            <div>
              <GridCanva state={generation.state} />
            </div>
          </div>
        )
      }
    </div>
  );
};

export default BoardList;
