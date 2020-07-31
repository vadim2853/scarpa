import React, { PropTypes } from 'react';

import bindAll from '../../../lib/helpers/bind-all';

export default class PostForm extends React.Component {
  static propTypes = {
    postComment: PropTypes.func.isRequired,
    level: PropTypes.number.isRequired,
    rows: PropTypes.string.isRequired,
    url: PropTypes.string.isRequired,
  };

  constructor(props, context) {
    super(props, context);

    this.state = {
      vale: '',
    };

    bindAll(this, 'handleChange', 'submit');
  }

  handleChange(event) {
    this.setState({ value: event.target.value });
  }

  submit() {
    if (!this.state.value) return;

    this.props.postComment(this.props.url, this.state.value);
    this.setState({ value: '' });
  }

  render() {
    return (
      <div className={`article__leave_comment level_${this.props.level}`}>
        <textarea
          placeholder="I would love to say"
          onChange={this.handleChange}
          value={this.state.value}
          rows={this.props.rows}
        />

        <button className="btn red x-small" type="submit" onClick={this.submit}>Comment</button>
        <div className="clear"></div>
      </div>
    );
  }
}
