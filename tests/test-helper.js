import { setApplication } from '@ember/test-helpers';
import * as QUnit from 'qunit';
import { setup } from 'qunit-dom';
import { start } from 'ember-qunit';

import Application from 'package-majors/app';
import config from 'package-majors/config/environment';

setApplication(Application.create(config.APP));

setup(QUnit.assert);

start();
