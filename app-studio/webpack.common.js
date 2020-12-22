let path = require('path');
let webpack = require('webpack');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

module.exports = {
  entry: {
    vendor: path.resolve(__dirname, 'src/main/webapp/search/app/vendor.js'),
    app: path.resolve(__dirname, 'src/main/webapp/search/app/app.js')
  },
  module: {
    rules: [{
      test: /\.js$/,
      use: [{
        loader: 'ng-annotate-loader',
        options: { add: true }
      }, {
        loader: 'babel-loader',
        options: { babelrc: true}
      }
      ],
      include: [
        path.resolve(__dirname, 'src/main/webapp/search')
      ]
    },
    {
        test: /\.html$/,
        use: [{
            loader: 'html-loader',
            options: {interpolate: true}
        }]
    },
    {
      test: /\.css$/,
      use: ['style-loader', 'css-loader']
    },
    {
      test: /\.(woff|ttf|eot|svg|png|jpg|gif|ico)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
      loader: 'file-loader?name=[name].[ext]'
    }
    ]
  },
  plugins: [
    new webpack.IgnorePlugin(/\.\/locale$/),
    new MiniCssExtractPlugin({
        filename:'main.css'
    })
  ],
  target: 'web'
};
