require 'test_helper'

class TaoEditorTest < ActiveSupport::TestCase

  test 'version number' do
    assert TaoEditor::VERSION.is_a? String
  end

  test 'TaoEditor::Engine inherits from Rails::Engine' do
    assert TaoEditor::Engine < Rails::Engine
  end

end
