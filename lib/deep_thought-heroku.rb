require 'deep_thought'
require 'deep_thought-heroku/deployer/heroku'

module DeepThought
  DeepThought::Deployer.register_adapter('heroku', DeepThought::Deployer::Heroku)
end
