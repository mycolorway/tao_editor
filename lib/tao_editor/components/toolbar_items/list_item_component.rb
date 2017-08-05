module TaoEditor
  module Components
    module ToolbarItems
      class ListItemComponent < Base

        def self.component_name
          :editor_toolbar_list_item
        end

        private

        def default_options
          merge_options super, {
            class: 'tao-editor-toolbar-list-item'
          }
        end
      end
    end
  end
end
