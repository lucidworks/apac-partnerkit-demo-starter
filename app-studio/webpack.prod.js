const merge = require('webpack-merge');
const path = require('path');
const common = require('./webpack.common.js');
let autoprefixer = require('autoprefixer');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

module.exports = env => {
    const appName = env && env.APP_NAME ? env.APP_NAME : 'app-studio-enterprise';
    return merge(common, {

        mode: 'production',

        output: {
            path: path.resolve(__dirname, 'target/'+ appName + '/dist'),
            filename: '[name].bundle.js'
        },

        module: {
            rules: [
                {
                    test: /\.less$/,
                    use: [MiniCssExtractPlugin.loader,
                        {
                            loader:'css-loader',
                            options: {
                                minimize: true
                            }
                        },
                        {
                            loader: 'postcss-loader',
                            options: {
                                plugins: [
                                    autoprefixer({ browsers: ['last 2 versions'] })
                                ]
                            }
                        },
                        {
                            loader:'less-loader'
                        }
                    ]
                }
            ]
        }
    });
};
