require('jasmine-reporters');

// An example configuration file.
exports.config = {
  // The path to selenium jar
  seleniumServerJar: '/vagrant/selenium-server-standalone-2.38.0.jar',

  seleniumPort: 4444,

  // The address of a running selenium server.
  seleniumAddress: 'http://localhost:4444/wd/hub',

  // Capabilities to be passed to the webdriver instance.
  capabilities: {
    'browserName': 'phantomjs',
    'phantomjs.binary.path':'/usr/lib/nodejs/node-v0.10.22-linux-x64/lib/node_modules/phantomjs/bin/phantomjs'
  },

  // baseUrl: 'http://angularjs.org',

  rootElement: 'body',

  // Spec patterns are relative to the current working directly when
  // protractor is called.
  specs: ['corpfolder-*.js'],

  onPrepare: function() {
    jasmine.getEnv().addReporter(
      new jasmine.JUnitXmlReporter('xmloutput', true, true));
  },

  // Options to be passed to Jasmine-node.
  jasmineNodeOpts: {
    onComplete: null,
    isVerbose: false,
    showColors: true,
    includeStackTrace: false,
    defaultTimeoutInterval: 30000
  }
};