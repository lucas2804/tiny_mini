import mockTasks from './MockTask';

export default function tasks(state = { tasks: mockTasks }, action) {
  if (action.type === 'CREATE_TASK') {
    return { tasks: state.tasks.concat(action.payload) }
  }
  return state;
}
