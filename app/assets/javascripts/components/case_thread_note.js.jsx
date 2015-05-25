
var CaseThreadNote = React.createClass({
  getInitialState: function(){
    return {showBody: false}
  },

  onClick: function(){
    return this.setState({ showBody: !this.state.showBody})
  },

  render: function(){
    console.log(this.props);
    return <div  className="panel panel-info pull-right" style={{width:'60%'}}>
        <div onClick={this.onClick} className="panel-heading panel-note" style={{margin: 0}}>
          <h4 className="pull-left" style={{margin:0}}>Note</h4>
          <font style={{color:'black', paddingLeft:20, fontWeight:'bold'}}>{this.props.note.subject}</font>
          <p className="pull-right" style={{color:'black', fontSize:10, marginTop:-7}}>
            <b>Added by:</b><br/>
            {this.props.user}
          </p>
        </div>
        {this.state.showBody ?
        <div className="panel-body toggler" >
          <p >
            {this.props.note.body}
          </p>
        </div> : null }
      </div>;

  }


});