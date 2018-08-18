import React, { Component } from 'react';
import TaskList from './TaskList';
import NewTaskForm from './Form';

const TASK_STATUSES = ['Unstarted', 'In Progress', 'Completed'];

class TasksPage extends Component {
  constructor(props) {
    super(props);
    this.state = {
      showNewCardForm: false,
      title: '',
      description: '',
    }
  };
  
  onTitleChange = (e) => {
    this.setState({ title: e.target.value });
  };
  
  onDescriptionChange = (e) => {
    this.setState({ description: e.target.value })
  };
  
  resetForm() {
    this.setState({
      showNewCardForm: false,
      title: '',
      description: ''
    });
  };
  
  onCreateTask = (e) => {
    e.preventDefault();
    this.props.onCreateTask({
      title: this.state.title,
      description: this.state.description
    });
    this.resetForm();
  };
  
  toggleForm = () => {
    this.setState({ showNewCardForm: !this.state.showNewCardForm })
  };
  
  renderTaskLists() {
    const { tasks } = this.props;
    return TASK_STATUSES.map(status => {
      const statusTasks = tasks.filter(task => task.status === status);
      
      return (
        <TaskList key={status} status={status} tasks={statusTasks}/>
      )
    })
  };
  
  render() {
    return (
      <div className="task-lists">
        <div className="task-list-header">
          <button onClick={this.toggleForm} className="button button-default">
            + New task
          </button>
          
          {/* FORM */}
          {this.state.showNewCardForm &&
          <NewTaskForm onCreateTask={this.onCreateTask}
                       onDescriptionChange={this.onDescriptionChange}
                       onTitleChange={this.onTitleChange}
                       description={this.state.description}
                       title={this.state.title}
          />
          
          }
          
          {/* TASK LISTs */}
          <div className="task-lists">
            {this.renderTaskLists()}
          </div>
        
        
        </div>
      </div>
    )
  }
}

export default TasksPage;
