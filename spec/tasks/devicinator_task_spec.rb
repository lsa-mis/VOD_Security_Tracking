# spec/tasks/devicinator_task_spec.rb
# spec/system/devicinator_task_spec.rb
require 'rails_helper'
require 'rake' # Require Rake

RSpec.describe 'devicinator task', type: :system do
  before :all do
    Rails.application.load_tasks # Make sure all Rake tasks are loaded
  end

  after :all do
    Rake::Task['devicinator'].reenable # Ensure the task can be run again if needed
  end

  it 'performs the expected task' do
    # Invoke the rake task
    Rake::Task['devicinator'].invoke
    
    # Place any assertions here to check the effects of your task
    # For example, checking if device attributes are updated correctly
  end
end

