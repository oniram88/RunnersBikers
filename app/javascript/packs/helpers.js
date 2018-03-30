import _ from 'lodash';

export function mapStateFeedbackListCmp(...fields) {

  let o = {}

  _.each(fields, (i) => {

    o[`${i}_error_obj`] = function () {
      // console.log(this, i, 'error_obj', this.errors);
      if (this.errors) {
        return _.find(this.errors, function (o) {
          return o.field == i;
        }) || false;
      }
      return false;
    };

    o[`${i}_state`] = function () {
      // console.log(this, i, 'state', this.errors);
      let obj_key = `${i}_error_obj`
      if (this.show_errors) {
        if (this[obj_key]) {
          return 'invalid';
        } else {
          return 'valid';
        }
      }else{
        return '';
      }
    };

    o[`${i}_feedback`] = function () {
      // console.log(this, i, 'feedback', this.errors);
      let obj_key = `${i}_error_obj`
      if (this.show_errors) {
        if (this[obj_key]) {
          return this[obj_key].message[0];
        }
      } else {
        return '';
      }
    }

  });

  return o;

}