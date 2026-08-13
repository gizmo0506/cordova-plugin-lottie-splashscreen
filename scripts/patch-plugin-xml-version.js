const fs = require('fs');
const path = require('path');

const packageJson = require('../package.json');
const pluginXmlPath = path.join(__dirname, '../plugin.xml');
const version = packageJson.version;

const pluginXml = fs.readFileSync(pluginXmlPath, 'utf8');
const updated = pluginXml.replace(/(id="[\w\.-]+" version=")([\w\.-]+)(")/, `$1${version}$3`);

fs.writeFileSync(pluginXmlPath, updated);
