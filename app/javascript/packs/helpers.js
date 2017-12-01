import _ from 'lodash';

export function mapStateFeedbackListCmp(...fields) {

  let o = {}

  _.each(fields, (i) => {

    o[`${i}_state`] = function () {
      // console.log(this, i, 'state', this.json_errors);
      if (this.errors && this.errors[i]) {
        return this.errors[i] ? 'invalid' : 'valid'
      } else {
        return '';
      }
    };

    o[`${i}_feedback`] = function () {
      // console.log(this, i, 'feedback',this.json_errors);
      if (this.show_errors) {
        return this.errors[i] ? this.errors[i][0] : ''
      } else {
        return '';
      }
    }

  });

  return o;

}