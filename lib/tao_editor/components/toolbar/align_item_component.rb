module TaoEditor
  module Components
    module Toolbar
      class AlignItemComponent < BaseItemComponent

        def self.component_name
          :editor_toolbar_align_item
        end

        private

        def default_options
          merge_options super, {
            class: 'tao-editor-toolbar-align-item'
          }
        end
      end
    end
  end
end
