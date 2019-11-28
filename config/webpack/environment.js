const { environment } = require('@rails/webpacker');
const erb =  require('./loaders/erb');
const webpack = require("webpack");
environment.plugins.append(
"Provide",
new webpack.ProvidePlugin({
$: "jquery",
jQuery: "jquery",
Popper: ["popper.js", "default"],
_: 'underscore'
})
);
environment.loaders.prepend('erb', erb)
module.exports = environment;

environment.loaders.append('gmaps4rails', {
  test: /gmaps_google/,
  use: [
    {
      loader: 'imports-loader',
      options: 'this=>window'
    }
  ]
});
