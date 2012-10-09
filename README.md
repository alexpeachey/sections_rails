# Sections for Rails <a href="https://codeclimate.com/github/kevgo/sections_rails" target="_blank"><img src="https://codeclimate.com/badge.png" /></a>

_SectionsRails_ adds a component-oriented infrastructure to the view layer of Ruby on Rails.

In short, the DOM, styling, behavior, tests, and other data for dedicated pieces of a web page are defined together, in one directory,
rather than spread across _app/views_, _app/assets/javascripts_, _app/assets/stylesheets_, and _spec/javascripts_.
This makes it easier to work on those pieces, makes them more reusable, and large code bases more managable.


## Example

Let's take the navigation menu within a web site as an example section.
It consists of certain HTML, CSS, and JavaScript code as well as image resources.
These assets must be loaded on every page that this navigation menu is visible on,
and should be removed when the navigation menu is removed from the site.

Traditionally, these files are defined in this directory structure:

```
/app/assets/images/background.gif
           /javascripts/menu.js
                       /templates/entry.jst.ejs
           /stylesheets/menu.css
    /views/shared/_menu.html.erb
/doc/menu.markdown
/public/about_us.pdf
/spec/javascripts/menu_spec.js
```

_Sections_rails_ allows to define these assets together, as a _section_ inside the _/app_ folder:

    /app/sections/menu/_menu.html.erb     # Server side template.
                       about_us.pdf       # Static asset used in this section.
                       background.gif     # Image resource for this section.
                       entry.jst.ejs      # Client-side template.
                       menu.css           # Styling for the menu.
                       menu.js            # Logic for the menu.
                       menu_spec.coffee   # Unit test for logic of this template.
                       readme.md          # Documentation.

To embed this menu and all its assets into a page, simply do this in your view:

```erb
<%= section :menu %>
```

This command inserts the partial as well as the JS and CSS files from _/app/sections/menu_ into the page.

It does the right thing in all circumstances: In development mode it inserts the individual assets,
in production mode the assets are included into the precompilation targets.

The gem source comes with a bundled example Rails app in the _demo/_ directory.
It provides several working examples of sections in action in _views/demos/index.html.erb_.


## Installation

In your Gemfile:

```ruby
gem 'sections_rails'
```

Then set up the directory structure:

```bash
$ rails generate sections
```

The generator does the following things:

1.  It creates a new folder __/app/sections__,
    in which you put the source code for the different sections.

2.  It adds the folder _/app/sections_ to the asset pipeline by inserting this line into your _application.rb_ file:

        config.assets.paths << 'app/sections'

3.  It optionally creates a demo section called _hello_world_ that you can try out as described below.


In it's current prototypical implementation, _Sections_rails_ also creates empty asset container files:
__application_sections.js__ and __application_sections.css__.
Make sure you require them from your main _application.js_ and _application.css_ files.
They are used only when running _rake assets:precompile_ during deployment, and should be checked in and stay the way they are.


## Usage

To use the "hello_world" section created by the sections generator, simply add it to the view:

```erb
<%= section :hello_world %>
```

If your section renders itself completely in JavaScript, you can omit its partial file.
In this case, the _sections_ helper creates an empty div in the view.

```html
<div class="hello_world"></div>
```

### Options

By default, a section automatically includes partials, css, and js files with the section name if they exist.
This convention can be overridden. The following example renders the _hello_world_ section with a different partial, with no stylesheet,
and it uses the custom _foobar.js_ instead of _hello_world.js_.

```erb
<%= section :hello_world, partial: 'hello_new', css: false, js: 'foobar.js' %>
```

It is also possible to provide parameters to the rendered partial.

```erb
<%= section :hello_world, locals: { message: 'Greetings!' } %>
```

You can also provide a block to the section, which can be included into the partial by saying


### Inline blocks for sections.

You can provide a block to the section, like so:

```erb
<%= section :info_window do %>
  <h1>  Elaborate </h1>
  <div> Block     </div>
  <p>   content   </p>
<% end %>
```

This block can be included into the partial of the section using `yield`:
```erb
Partial content...
<%= yield %>
More partial content...
```

This allows to define the content of parts of the section dynamically in the calling view, using view helper methods.


### Creating new sections.

To create a new section, simply create a new folder under _/app/sections_ and add the partials, css, js, jst, and test files for this section.
Alternatively, run the provided generator:

```bash
$ rails generate section admin/chart
```

This creates a folder _/app/sections/admin/chart_ with a scaffold for a new section.


## Unit tests for sections

Sections should also contain unit test files for the section.


### Unit testing using Konacha

_This feature is still under development._

To test them for example using [Konacha](https://github.com/jfirebaugh/konacha), create a symlink to _app/sections_ in _spec/javascript_.


## Development

### Unit tests

```bash
$ rake
```

To automatically run unit tests when files change, run

```bash
$ bundle exec guard -c
```

### Missing features

_Sections_rails_ is far from complete. Some missing things are:

* Support for multiple application assets, for example page-specific compiled asset files instead of one global one.
* Support for serverside controller logic for sections, for example by integrating with https://github.com/apotonick/cells.
* More natural integration into the asset pipeline.


### Authors

* [Kevin Goslar](https://github.com/kevgo)
* [Serge Zinin](https://github.com/zininserge)
