# Deep Thought Heroku Deployer

Deploy to Heroku with Deep Thought.

## Install it

    gem install deep_thought-heroku

## Require it

In your Deep Thought's `config.ru`:

    require "deep_thought"
    require "deep_thought-heroku"

    DeepThought.setup(ENV)

    run DeepThought.app

## .deepthought.yml it

In your Heroku-bound projects, set the `deploy_type` to "heroku":

    deploy_type: heroku

Additionally, the Heroku deployer needs the remote repos for each environment's Heroku app:

    heroku:
      environments:
        development: git@heroku.com:development.git
        staging: git@heroku.com:staging.git
        production: git@heroku.com:production.git

## Use it

Pretty much Deep Thought as usual - deploy any branch to any environment.

As of right now, deploy actions do not do anything. In the roadmap is to map actions to `heroku run` tasks.

The only deploy variable recognized right now is "force" - setting `force = true` will do a force push to Heroku.

## Hack it

Find an issue? Want to make the deployer more robust?

Set it up:

    script/bootstrap

Create an `.env`:

    echo RACK_ENV=development > .env

Set up the databases (PostgreSQL):

    createuser deep_thought
    createdb -O deep_thought -E utf8 deep_thought_development
    createdb -O deep_thought -E utf8 deep_thought_test
    rake db:migrate

Test it:

    script/test

## Contribute it

1. Fork
2. Create
3. Code
4. Test
5. Push
6. Submit
7. Yay!
