const path = require("path");

//Webpack Stuff
const webpack = require("webpack");
const WebpackBundleAnalyzer = require("webpack-bundle-analyzer");

const Promise = require("bluebird");
const fs = Promise.promisifyAll(require("fs"));

const CONSTANTS = require("./core/contants");
require("dotenv").config();

let buildPath = `./${CONSTANTS.BUILD_PATH}/`;
var buildMode = process.env.MODE == CONSTANTS.PRODUCTION_MODE ? CONSTANTS.PRODUCTION_MODE : CONSTANTS.DEVELOPMENT_MODE;

(function () {
    return new Promise((resolve, reject) => {
        const webpackConfig = buildConfig(buildMode);
        const compiler = webpack(webpackConfig);
        new webpack.ProgressPlugin().apply(compiler);
        compiler.run((err, stats) =>
            err || stats.hasErrors() ? reject(err || stats.compilation.errors) : resolve(stats)
        );
    })
        .then((stats) => {
            console.log(stats.toString());
            // eslint-disable-next-line no-undef
            Promise.join(
                fs.readFileAsync(path.join(__dirname, buildPath, "grafieks-charts.js"), "utf-8"),
                (uncompressed) => [[{ minified: "test" }], uncompressed]
            );
        })
        .catch((err) => {
            console.log(`Error while creating webpack bundle and err is ${err}`);
            throw err;
        });
})();

function buildConfig(mode) {
    var buildConfig = {
        devtool: "source-map",
        mode,
        target: ["web", "es5"],
        stats: "normal",
        entry: [path.join(__dirname, "charts", "index.js")], // eslint-disable-line no-undef
        output: {
            path: path.join(__dirname, buildPath), // eslint-disable-line no-undef
            filename: "grafieks-charts.js"
        },
        module: {
            rules: [
                {
                    test: /\.m?js$/,
                    exclude: /(node_modules|bower_components)/,
                    use: {
                        loader: "babel-loader",
                        options: {
                            presets: ["@babel/preset-env"]
                        }
                    }
                }
            ]
        },
        plugins: [
            new webpack.DefinePlugin({
                TEST_CONSTANT: JSON.stringify(CONSTANTS.TEST_CONSTANT)
            })
        ]
    };

    // eslint-disable-next-line no-process-env, no-undef
    if (process.env.SHOW_BUNDLE_STATS) {
        buildConfig.plugins.push(new WebpackBundleAnalyzer.BundleAnalyzerPlugin());
    }

    return buildConfig;
}
