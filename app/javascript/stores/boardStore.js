import { create } from 'zustand';

const useBoardStore = create((set) => ({
  boards: [],
  addBoard: (board) => set((state) => ({ boards: [...state.boards, board] })),
}));

export default useBoardStore;