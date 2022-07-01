<div id="top"></div>

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/Grafieks-Analytics/grafieks-desktop">
    <img src="https://i.imgur.com/eisvJi9.png" alt="Logo" width="500">
  </a>

  <h3 align="center">Grafieks Desktop</h3>

  <p align="center">
    An open-source Business Intelligence platform built with Qt5, C++ and D3.js
    <br />
    <br />
    <a href="https://www.grafieks.com/pricing">Download & Try</a>
    ·
    <a href="https://github.com/Grafieks-Analytics/grafieks-desktop/issues">Report Bug</a>

  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation-and-setup">Installation and Setup</a></li>
      </ul>
    </li>
    <li><a href="#screenshots">Product Screenshots</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->

## About The Project
Grafieks is an open-source, simple Self-Service Business Intelligence tool that allows users to quickly and easily extract meaningful insights from data. With Grafieks, line-of-business professionals can connect to data sources, build data models or write SQL queries, and build reports on their own, with minimal IT support.

### Currently supported databases

**File based**

1. CSV
2. JSON
3. Microsoft Excel

**RDBMS**

1. Amazon Redshift
2. Microsoft Access
3. MySql
4. PostgresSQL
5. Sqlite
6. Snowflake
7. Micorosft Sql Server
8. Teradata

**NoSql**

1. Mongodb

**Cloud Storage**

1. Box
2. Dropbox
3. Google Drive

**Online Services**

1. Github Gists
2. Google Sheets

### Chart types

1.	Bar Chart<br />
    a)	Bar Chart <br />
    b)	Grouped Bar Chart <br />
    c)	Stacked Bar Chart <br />
    d)	Horizontal Bar Chart <br />
    e)	Horizontal Grouped Bar Chart <br />
    f)	Horizontal Stacked Bar Chart <br />
2.	Line Chart <br />
    a)	Line Chart  <br />
    b)	Horizontal Line Chart <br />
    c)	Multiple Line Chart <br />
3.	Area Chart <br />
    a)	Area Chart <br />
    b)	Stacked Area Chart <br />
4.	Pie Chart <br />
5.	Donut Chart <br />
6.	Radar Chart <br />
7.	Scatter Plot <br />
8.	Funnel <br />
9.	Gauge <br />
10.	Heat Map <br />
11.	Sunburst <br />
12.	Tree Chart <br />
13.	Waterfall Chart <br />
14.	Pivot <br />
15.	Table <br />


**Note:** Currently, it has been tested to work with Windows 10 and 11 only. On other OS, some of the features may not work.

<p align="right">(<a href="#top">back to top</a>)</p>

### Built With

Core technologies behind the application

-   [Qt5](https://www.qt.io/) - Only open-source modules used.
-   [C++ 11](https://isocpp.org)
-   [Javascript](https://www.ecma-international.org/publications-and-standards/standards/ecma-262/)
-   [D3js](https://d3js.org/)
-   [DuckDb](https://duckdb.org/)

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- GETTING STARTED -->

## Getting Started

This section gives a set of instructions on setting up your project locally. To get a local copy up and running follow these simple example steps.

##### When you clone for first time

```sh
git clone --recurse-submodules https://github.com/Grafieks-Analytics/grafieks-desktop/
```

##### Already cloned or missed cloning with -recurse-submodule flag

```sh
git submodule update --init
```

These commands will add a folder "Charts" at `Sources/` folder

### Prerequisites

Please choose whichever is applicable. You do not need to install all. e.g, if you need to process Mysql database, please download Mysql driver only.

Links to drivers for various databases to connect as datasource

#### Windows 10 & 11 drivers

1. [Amazon Redshift driver](https://docs.aws.amazon.com/redshift/latest/mgmt/configure-odbc-connection.html)
2. Microsoft Access. You need to have Microsoft office installed on your system
3. [Mongodb](https://www.mongodb.com/docs/bi-connector/current/installation/)
4. [MySql](https://dev.mysql.com/downloads/connector/odbc/)
5. [PostgresSQL](https://www.postgresql.org/ftp/odbc/versions/)
6. [Snowflake](https://sfc-repo.snowflakecomputing.com/odbc/index.html)
7. [Micorosft Sql Server](https://www.microsoft.com/en-in/download/details.aspx?id=36434)
8. [Teradata](https://downloads.teradata.com/tag/odbc)
9. Microsoft Excel. You need to have Microsoft office installed on your system

For those connectors not mentioned above, no special download is required. 

### Installation and Setup

-   For detailed installation and setup on Windows, [Refer this Document](https://github.com/Grafieks-Analytics/grafieks-desktop/blob/master/Documentation/Configuration%20Windows%2010.md)

-   **Duckdb v0.2.9** dll file is already included with the setup. However, if you manually want to install and setup **Duckdb** on Windows, [Refer this Document](https://github.com/Grafieks-Analytics/grafieks-desktop/blob/master/Documentation/DuckDB%20Installation.md).

-   To understanding the QML layout file, [Read this Document](https://github.com/Grafieks-Analytics/grafieks-desktop/blob/master/Documentation/Layouts.md)

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- ROADMAP -->

## Product Screenshots
**Data Connector Screen**

<img src="https://user-images.githubusercontent.com/425193/176872613-da4ab8cd-e515-4e51-b6fa-1bb3b857c957.png" width="800" />


**Report Designer Screen**

<img src="https://user-images.githubusercontent.com/79040963/176972231-e9230eb7-c914-4b29-90d3-7998385c6802.png" width="800" />

  
## Roadmap (till now)

-   [x] Connect to datasources
-   [x] Datasource filters, Report filters & Dashboard filters
-   [x] Publish datasources
-   [x] Generate reports
-   [x] Generate and publish dashboards

See the [open issues](https://github.com/Grafieks-Analytics/grafieks-desktop/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- CONTRIBUTING -->

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- LICENSE -->

## License

Distributed under the GPL v3 License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- CONTACT -->

## Contact

- Project Link: [https://www.grafieks.com/](https://www.grafieks.com/)
- Github: [https://github.com/Grafieks-Analytics/grafieks-desktop](https://github.com/Grafieks-Analytics/grafieks-desktop)


<p align="right">(<a href="#top">back to top</a>)</p>

<!-- ACKNOWLEDGMENTS -->

## Acknowledgments

We would like to thank the following repositories for their contribution to the open-source community

-   [DuckDb](https://duckdb.org)
-   [Nlohmann JSON](https://github.com/nlohmann/json)
-   [D3.js](https://github.com/d3/d3)

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[contributors-shield]: https://img.shields.io/github/contributors/Grafieks-Analytics/grafieks-desktop.svg?style=for-the-badge
[contributors-url]: https://github.com/Grafieks-Analytics/grafieks-desktop/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/Grafieks-Analytics/grafieks-desktop.svg?style=for-the-badge
[forks-url]: https://github.com/Grafieks-Analytics/grafieks-desktop/network/members
[stars-shield]: https://img.shields.io/github/stars/Grafieks-Analytics/grafieks-desktop.svg?style=for-the-badge
[stars-url]: https://github.com/Grafieks-Analytics/grafieks-desktop/stargazers
[issues-shield]: https://img.shields.io/github/issues/Grafieks-Analytics/grafieks-desktop.svg?style=for-the-badge
[issues-url]: https://github.com/Grafieks-Analytics/grafieks-desktop/issues
[license-shield]: https://img.shields.io/github/license/Grafieks-Analytics/grafieks-desktop.svg?style=for-the-badge
[license-url]: https://github.com/Grafieks-Analytics/grafieks-desktop/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/company/grafieks/
[product-screenshot]: product-scree.gif
