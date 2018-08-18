import React, { Component } from 'react';
import TasksPage from '././components/tasks/TasksPage';
import { connect } from 'react-redux'
import { createStore } from 'redux';
import { createTask } from "./components/tasks/action";

class App extends Component {
  onCreateTask = ({ title, description }) => {
    this.props.dispatch(createTask({ title, description }));
  };
  
  render() {
    console.log('props from App.js: ', this.props);
    return (
      <div className="main-content">
        <TasksPage tasks={this.props.tasks} onCreateTask={this.onCreateTask}/>
      </div>
    );
  }
}

// mapStateToProps to pass only relevant data to the component being connected
function mapStateToProps(state) {
  return {
    tasks: state.tasks
  }
}

export default connect(mapStateToProps)(App);
