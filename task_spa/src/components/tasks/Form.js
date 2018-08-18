import React from 'react';

const NewTaskForm = ({onCreateTask, onTitleChange, onDescriptionChange, title, description}) => (
  <form onSubmit={onCreateTask} className="task-list-form">
    <input onChange={onTitleChange}
           value={title}
           type="text" placeholder="title" className="full-width-input"/>
    
    <input onChange={onDescriptionChange}
           value={description}
           type="text" placeholder="description" className="full-width-input"/>
    
    <button type="submit" className="buntton">
      Save
    </button>
  </form>
);


export default NewTaskForm;
