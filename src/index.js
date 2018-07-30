import './main.css';
import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

require('dotenv').config({path: './.env'});

const app = Main.embed(document.getElementById('root'));

registerServiceWorker();

var Auth = require('./auth');
Auth.auth(app)
