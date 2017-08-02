module TaoEditor
  module Components
    module ToolbarItems
      class CommandItemComponent < Base

        def self.component_name
          :editor_toolbar_command_item
        end

        private

        def default_options
          merge_options super, {
            class: 'tao-editor-toolbar-command-item'
          }
        end
      end
    end
  end
end
