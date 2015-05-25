
var CaseThreadMail = React.createClass({
  getInitialState: function(){
    return {showBody: false}
  },

  onClick: function(){
    return this.setState({ showBody: !this.state.showBody})
  },

  render: function(){

    return <div className="panel panel-success pull-right" style={{width:'60%'}}>
      <div onClick={this.onClick} className="panel-heading panel-email">
        <h4 className="pull-left" style={{margin:0}}>Email</h4>
        <font style={{color:'black', paddingLeft:20, fontWeight:'bold'}}>{this.props.email.subject}</font>
      </div>
      {this.state.showBody ?
        <div className="panel-body toggler">
          From: <font color="#999999" size="3">{this.props.email.from}</font>
          To: <font color="#999999" size="3">{this.props.email.to}</font>
          Sent: <font color="#999999" size="3">{this.props.email.sent}</font>
          <legend></legend>
          {this.props.email.body}
        </div> : null}
    </div>;

  }

});
