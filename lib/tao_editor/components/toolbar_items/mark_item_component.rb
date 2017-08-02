module TaoEditor
  module Components
    module ToolbarItems
      class MarkItemComponent < Base

        def self.component_name
          :editor_toolbar_mark_item
        end

        private

        def default_options
          merge_options super, {
            class: 'tao-editor-toolbar-mark-item'
          }
        end
      end
    end
  end
end
