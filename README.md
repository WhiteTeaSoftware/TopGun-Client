# TopGun-Client

A location based messaging service

Note: this requires a TopGun-Server instance running!
Change hostUrl on line 3 of src/scripts/service.coffee to point to your server.

## Requirements

TG requires NPM installed on your local machine. It is usually bundled with
Node.JS. After NPM is installed, run

    npm install -g cordova ionic grunt-cli bower

to install everything TG needs to run.

## Installing Dependencies

TG requires several dependencies from several sources. First, install the build
dependencies with

    npm install

then install the runtime dependencies with

    bower install

Once you've this, everything you need to run TG will be in the directory
under the folders bower_components and node_modules.

## Building

To build TG run

    grunt

This will build the app for a production environment as well as install the
ngCordova dependencies. The build output can be found in the www directory.
There should be three files, index.html, app.js, and app.css. These files
contain the minimized code for everything, including JS and CSS libraries, as
well as templates. fonts and images can be found in there respective folders.

## Running

To run TG, run

    npm start

or

    ionic serve
