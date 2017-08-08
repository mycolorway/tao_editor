module TaoEditor
  module Components
    module ToolbarItems
      class TableItemComponent < MenuItemComponent

        def self.component_name
          :editor_toolbar_table_item
        end

        private

        def default_options
          merge_options super, {
            class: 'tao-editor-toolbar-table-item'
          }
        end
      end
    end
  end
end
