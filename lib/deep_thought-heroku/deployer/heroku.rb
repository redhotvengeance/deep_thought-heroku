require 'deep_thought/deployer/deployer'

module DeepThought
  module Deployer
    class Heroku < DeepThought::Deployer::Deployer
      def setup?(project, config)
        environments = config['heroku']['environments']

        if environments
          environments.each do |k, v|
            system "cd ./.projects/#{project.name} && git remote add #{k} #{v} > /dev/null 2>&1"
          end
        else
          false
        end
      end

      def execute?(deploy, config)
        environment = deploy.environment || "development"

        variables = Hash.new

        if deploy.variables
          YAML.load(deploy.variables).each do |k, v|
            variables[k] = v;
          end
        end

        force = false

        if variables['force']
          force = true
        end

        result = push_to_heroku(deploy.project.name, environment, deploy.branch, force)

        deploy.log = result['log']

        result['success']
      end

      private

      def push_to_heroku(name, environment, branch, force = false)
        push_command = "git push"

        if force
          push_command += " -f"
        end

        push_command += " #{environment} #{branch}:master"

        commands = []

        commands << "cd ./.projects/#{name}"
        commands << "#{push_command} 2>&1"

        command = commands.join(" && ")

        log = `#{command}`

        result = Hash.new

        result['log'] = log
        result['success'] = $?.success?

        result
      end
    end
  end
end
