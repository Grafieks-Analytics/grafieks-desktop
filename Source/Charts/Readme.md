# Grafieks Charts

## How to build grafieks-charts.js

Built on node version v14.1.0

```
    npm install
    npm run build
```

## How it works

-   All the charts files are bundled into grafieks-charts.js and moved to path `build/grafieks.js`.
-   There is a file `index.html`. It requires this built version of `grafieks.js`.

## How to add a new Chart

-   Add a new module in `charts/chartsModules` folder
-   Name it as `<chart_name>.js`
