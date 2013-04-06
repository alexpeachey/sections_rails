# Sections for Rails [![Build Status](https://travis-ci.org/kevgo/sections_rails.png?branch=master)](https://travis-ci.org/kevgo/sections_rails) [![Code Climate](https://codeclimate.com/github/kevgo/sections_rails.png)](https://codeclimate.com/github/kevgo/sections_rails) [![Coverage Status](https://coveralls.io/repos/kevgo/sections_rails/badge.png?branch=master)](https://coveralls.io/r/kevgo/sections_rails)

_A component-oriented infrastructure for the view layer of Ruby on Rails applications._

A _section_ organizes all assets (DOM, styling, behavior, tests etc) for a particular component of a web site (a menu, a navbar, a slideshow etc)
together. This makes development easier, components more reusable, and large code bases more managable.


## Example

A navigation menu (as an example for a component) within a web site consists of HTML, CSS, and JavaScript code, image resources, as well as unit tests.
Traditionally, these files are defined in a directory like this:

    /app/assets/images/background.gif                   # Background image.
               /javascripts/menu.js                     # Logic for the menu.
                           /templates/entry.jst.ejs     # Client-side template for menu entries.
               /stylesheets/menu.css                    # Styling.
        /views/shared/_menu.html.erb                    # Server-side template.
    /spec/javascripts/menu_spec.js                      # Unit tests.

_Sections_rails_ allows to define these assets together, as a _section_, inside the _/app_ folder:

    /app/sections/menu/_menu.html.erb
                       background.gif
                       entry.jst.ejs
                       menu.css
                       menu.js
                       menu_spec.coffee

To embed this menu into a page, simply do this in your view:

```erb
<%= section :menu %>
```

This command inserts the partial as well as the JS and CSS files from _/app/sections/menu_ into the page.

It does the right thing in all circumstances: In development mode it inserts the individual files into the page,
in production mode they are included into the compiled output.
And when the menu folder is deleted or moved to another page,
all assets of the menu are cleanly deleted or moved with it!


## Example applications

The gem source comes with a bundled example Rails app in the [demo](https://github.com/kevgo/sections_rails/tree/master/demo) directory.
Start it up and [check it out](http://localhost:3000)!
The source code for the sections is [here](https://github.com/kevgo/sections_rails/tree/master/demo/app/sections).


## Installation

In your Gemfile: `gem 'sections_rails'`, then set up the directory structure:

```bash
$ rails generate sections
```

The generator

*  creates a new folder __/app/sections__, in which you put the source code for the different sections.

*  adds the folder _/app/sections_ to the asset pipeline by inserting this line into your _application.rb_ file:

        config.assets.paths << 'app/sections'

*  optionally creates a demo section called _hello_world_ that you can try out as described below.


The current implementation requires two empty asset container files: __application_sections.js__ and __application_sections.css__.
Make sure you require them from your main _application.js_ and _application.css_ files.
They are used only when running _rake assets:precompile_ during deployment, should be checked into your code repository, and stay the way they are.


## Usage

To show the "hello_world" section created by the sections generator on a page:

```erb
<%= section :hello_world %>
```

If your section renders itself completely in JavaScript, you can omit its partial file.
In this case, the _sections_ helper creates an empty div with the section name as its class.

```html
<div class="hello_world"></div>
```

By default, a section automatically includes partials, css, and js files with the section name if they exist.
This convention can be overridden.


### Customizing the filename of the section's partial.

```erb
<%= section :hello_world, partial: 'another_partial' %>
```


### Customizing the filename of the assets

To tell the section to use `foobar.js` instead of `hello_world.js`:

```erb
<%= section :hello_world, js: 'foobar.js' %>
```


### Omitting assets

Sections can be told not not include their css or js file when rendered.

```erb
<%= section :hello_world, css: false %>
```

### Providing parameters to the partial

```erb
<%= section :hello_world, locals: { message: 'Greetings!' } %>
```

### Inline blocks for sections.

You can provide a block to the section:

```erb
<%= section :info_window do %>
  <h1>  inline  </h1>
  <div> block   </div>
  <p>   content </p>
<% end %>
```

This block can be included into the serverside partial of the section using `yield`.


### Creating new sections.

To create a new section, simply create a new folder under _/app/sections_.
There is also a generator for your convenience, which creates a whole scaffolded section.

```bash
$ rails generate section admin/chart
```


### Unit tests for sections

Sections should also contain unit test files for the section.

To run your section tests using [Konacha](https://github.com/jfirebaugh/konacha), create a symlink to _app/sections_ in _spec/javascript_.


## How to contribute

Feel free to send unit-tested pull requests! The unit tests of this project are run using `rake`.


### Missing features

_Sections_rails_ is far from complete. Some missing things are:

* Support for multiple application assets, for example page-specific compiled asset files instead of one global one.
* Support for serverside controller logic for sections, for example by integrating with https://github.com/apotonick/cells.
* More natural integration into the asset pipeline.


### Authors

* [Kevin Goslar](https://github.com/kevgo)
* [Serge Zinin](https://github.com/zininserge)
