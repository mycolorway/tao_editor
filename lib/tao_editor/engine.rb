require 'tao_on_rails'
require 'tao_ui'
require 'tao_form'
# require 'tao_editor/components'

module TaoEditor
  class Engine < Rails::Engine

    config.eager_load_paths += Dir["#{config.root}/lib"]

    config.i18n.load_path += Dir[config.root.join('config', 'locales', '**', '*.{rb,yml}')]

    paths['app/views'] << 'lib/views'

    ::ActiveSupport.on_load :tao_components do
      load_tao_components TaoEditor::Engine.root
    end

  end
end
