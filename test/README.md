In order to consolidate various test scripts developed by IGN's QA team, the team is using a unified framework that will be the main entry point for all automated tests and scripts. 

## REQUIRED SOFTWARE
Below are the required software and gems you need to install to run this framework.

### Ruby
All tests are developed in Ruby (version 1.9.2). Highly recommended using RVM to install and set-up Ruby http://www.rvm.io/

### Ruby Gems
rspec (the test framework all tests are developed in https://www.relishapp.com/rspec)
json_pure (a json parser, mainly used to parse IGN's APIs)
nokogiri (an HTML parser, maoinly used to parse IGN webpages that don't require javascript testing)
rake (used to run tests)
rest-client (an HTTP client)
selenium-webdriver (_the_ browser automation tool http://docs.seleniumhq.org/projects/webdriver/)
colorize (easy way to make console output colorful, e.g.: "hello world".green)

### Git
How to set up GIT on a Mac - http://help.github.com/mac-set-up-git/

## FRAMEWORK 

All tests will be written using the Rspec2 framework - https://www.relishapp.com/rspec

The current folder structure:

- media-qa
  - test
    - config
    - spec
    - lib
	- scripts

The 'config' folder contains a list of all known DNS entires for all apps.
The 'spec' folder is a repository for all tests.
The 'lib' folder contains all helper classes required by tests.
The 'scripts' folder contains one-off scripts used for improptu needs.

To run all tests suites:

   cd media-qa/test
   rake all [OPTIONS] [TAGS] (options and tags explained below)

To run all API tests:

   cd media-qa/test
   rake backend [OPTIONS] [TAGS]
   
As new projects are added there will be rake tasks for running those projects like:
    rake cheats [OPTIONS] [TAGS]
    rake social [OPTIONS] [TAGS]
    rake object-api [OPTIONS] [TAGS]

### What are [OPTIONS]?

To run tests for each application, you need to pass more than "rake [APPLICATION]". You also have to pass options. All tests require an 'env' variable to determine which environment to run against. E.g.:

	rake some-feature env=production # environments are defined in the .yml files under the config dir

All Phantom (frontend) tests require a 'services' variable to determine which environment services to use. For example, to run tests against pages using staging services, do:

	rake videoplayerpage services=staging # service environments are defined in the .yml files under the config dir

All tests that use Selenium require a browser variable. For example:

	rake videoplayerpage browser=firefox 

An optional variable is 'branch'. This applies to most frontend tests (and all Phantom tests) and lets you run against any given stage branch. For example:

	rake videoplayerpage branch=test-stg-branch # will run tests against the test-stg-branch

### What are [TAGS]?

Tags are used to label tests. You can then run tests with only certain labels or run tests excluding certain labels.

For smoke/basic assertions, use the tag 'smoke'
For assertions that spam the site or take a long time to run (for example, checking all the links on the page), use the tag 'spam'
For assertions only valid in a staging environment, use the tag 'stg'
For assertion only valid in the production environment, use the tag 'prd'

Here's an example of using an RSpec tag in your spec file:

      it "should have at least one link", :smoke => true do
          check_have_a_link('div#right-col-outnow-tabs')
      end

To run only the assertions tagged 'smoke' in the frontend testsuite, I use the following command to include only smoke assertions
  rake frontend env=production SPEC_OPTS='--tag test'

To run the frontend test without the assertions tagged 'spam, I use the following command to exclude all spam assertions
	rake frontend env=production SPEC_OPTS='--tag ~spam'

To run the frontend testsuite in production without the staging-only assertions, I use the following command to  exclude all stage assertions
	rake frontend env=production SPEC_OPTS='--tag ~stg'
	
### Real Use Case Examples

	rake object-api env=staging SPEC_OPTS='--tag ~prd' # runs object api tests, excluding production-only test cases, in stage

	rake videoplayerpage env=production services=production browser=firefox SPEC_OPTS='--tag ~spam' # runs the tests for the video
	# player page in production using Firefox as the browser. Excludes all tests tagged 'spam' (e.g., link checkers)

	rake hubs env=staging branch=new-feature-branch # runs all tests for IGN's hub pages against the new-feature-branch staged