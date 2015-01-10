# My Academic Webpage skeleton for [DocPad](https://github.com/bevry/docpad)

>   Bare essentials for building a modern website with best practices

This is a fork of the skeleton [HTML5 Boilerplate with Grunt for Docpad](https://github.com/lukekarrys/html5-boilerplate.docpad) by [lukekarrys](https://github.com/lukekarrys).


## Why the fork?
This fork puts some more structure and some starting layout on top of the original skeleton (which is a boilerpate for itself). 
You shall see the [Original README](https://github.com/lukekarrys/html5-boilerplate.docpad/blob/master/README.md).

This HTML5 Boilerplate skeleton for DocPad contains layout and structure with bare essentials for building a modern web page following also some modern best practices. 

**Ideally, if you clone this repo things will be almost ready for you to have a personal webpage online in no time**, just some configurations need to be changed, and - naturally - some content.


## Getting Started

1. [Install DocPad](https://github.com/bevry/docpad)

2. Clone the project and run the server: open the terminal and run the following commands

	``` bash
	git clone git@github.com:kuzeko/Academic-Webpage-Docpad-Boilerpate.git my-page
	cd my-page
	npm install
	docpad run
	```
    this last command will keep running and keping busy your terminal

3. [Open http://localhost:8080/](http://localhost:8080/) and you see the current content

4. Start hacking away by modifying the `src` directory
    1. edit the properties in the file `docpad.coffee`
    2. customize the variables in `src/render/styles/style.css.scss` 
    3. replace the text in `src/render/index.html.eco`

5. you shall see the webapge in your browser reloading with new content, otherwise `CTRL + C` terminated the `docpad run` command, and then re-run it.


## Includes

1. [jQuery JavaScript Library v1.11.2](http://jquery.com/)

2. [Modernizr v2.8.3, Minimum custom build](http://modernizr.com/)

3. [normalize.css v3.0.2](http://necolas.github.io/normalize.css/)

See `src/static/humans.txt` for a complete colophon.

## File Structure

    .
    ├── LICENSE.md              <- your rights on this code
    ├── README.md              <- This file
    ├── bin                           <- Script to deploy in production the website
    ├── .env                         <- Conguration file for the deployment script [TO BE EDITED]
    ├── docpad.coffee           <- Configuration file [TO BE EDITED]
    ├── grunt-config.json      
    ├── grunt.js
    ├── package.json             <- List of things that will be installed automatically
    └── src                            <- The real content and structure [TO BE EDITED]

## License
    
    Copyright (C) 2014  Matteo Lissandrini a.k.a. Kuzeko

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.


    Other included things such as themes and libraries are likely already 
    licensed by their own invidual licenses, so be sure to respect their licenses too.

