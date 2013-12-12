require File.expand_path '../test_helper.rb', __FILE__

class DeepThoughtHerokuTest < MiniTest::Unit::TestCase
  def setup
    DatabaseCleaner.start

    if File.directory?(".projects/_test")
      FileUtils.rm_rf(".projects/_test")
    end

    DeepThought::Deploy.any_instance.stubs(:queue)

    @project = DeepThought::Project.create(:name => '_test', :repo_url => './test/fixtures/project-test')
    @user = DeepThought::User.create(:email => 'test@test.com', :password => 'secret', :password_confirmation => 'secret')
    @deploy = DeepThought::Deploy.create(:project_id => @project.id, :user_id => @user.id, :branch => 'master', :commit => '12345')
    @deployer = DeepThought::Deployer::Heroku.new
    @project.setup
  end

  def teardown
    if File.directory?(".projects/_test")
      FileUtils.rm_rf(".projects/_test")
    end

    DatabaseCleaner.clean
  end

  def test_heroku_execute_success
    @deployer.stubs(:push_to_heroku).with(@project.name, 'development', @deploy.branch, false).returns({'log' => '', 'success' => true})
    assert @deployer.setup?(@project, YAML.load_file(".projects/#{@project.name}/.deepthought.yml"))
    assert @deployer.execute?(@deploy, {})
    assert @deploy.log
  end

  def test_heroku_execute_failed
    @deployer.stubs(:push_to_heroku).with(@project.name, 'development', @deploy.branch, false).returns({'log' => '', 'success' => false})
    assert @deployer.setup?(@project, YAML.load_file(".projects/#{@project.name}/.deepthought.yml"))
    assert !@deployer.execute?(@deploy, {})
    assert @deploy.log
  end

  def test_heroku_force_push
    @deploy.variables = {'force' => true}.to_yaml
    @deployer.stubs(:push_to_heroku).with(@project.name, 'development', @deploy.branch, true).returns({'log' => '', 'success' => true})
    assert @deployer.setup?(@project, YAML.load_file(".projects/#{@project.name}/.deepthought.yml"))
    assert @deployer.execute?(@deploy, {})
    assert @deploy.log
  end
end
