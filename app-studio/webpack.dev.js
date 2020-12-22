const merge = require('webpack-merge');
const path = require('path');
const common = require('./webpack.common.js');
let autoprefixer = require('autoprefixer');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

const config = merge(common, {
  mode: 'development',
  devtool: 'cheap-eval-source-map',

    output: {
        path: path.resolve(__dirname, 'src/main/webapp/dist'),
        filename: '[name].bundle.js'
    },

  module: {
    rules: [{
        test: /\.less$/,
        use: [MiniCssExtractPlugin.loader,
            {
                loader:'css-loader',
                options: {
                    sourceMap: true
                }
            },
            {
                loader: 'postcss-loader',
                options: {
                    plugins: [
                        autoprefixer({ browsers: ['last 2 versions'] })
                    ],
                    sourceMap: 'inline'
                }
            },
            {
                loader:'less-loader', // Use operations applied last to first.
                options: {
                    sourceMap: true
                }
            }
        ]
    }]
  }
});

module.exports = config;
