/**
 * File che racchiude tutte le configurazioni authorizzatize visuali
 * è un hash contenente come chiave il soggetto da analizzare
 * e ogni soggetto ha un hash di vari metodi che mi ritornano true o false
 * per autorizzare o meno qualcosa
 */

import axios from 'axios';

export default {
  '*': {
    '*': (value, opts) => {
      return new Promise(function (s) {
        axios.get(Routes.authorization_request_path(
          opts.subject,
          value,
          opts.action,
        )).then(() => {
          s(true);
        }, () => {
          s(false);
        });

      });
    }
  }
};