import { uniqueId } from "./action";

const mockTasks = [
  {
    id: uniqueId(),
    title: 'Learn Redux',
    description: 'The store actions and reducers omg',
    status: 'In Progress',
  },
  {
    id: uniqueId(),
    title: 'Peace on Earth',
    description: 'No big deal.',
    status: 'In Progress'
  },

  {
    id: uniqueId(),
    title: 'title Unstarted',
    description: 'The store actions and reducers omg',
    status: 'Unstarted',
  },
  {
    id: uniqueId(),
    title: 'title Unstarted 2',
    description: 'No big deal.',
    status: 'Unstarted'
  },

];


export default mockTasks;
