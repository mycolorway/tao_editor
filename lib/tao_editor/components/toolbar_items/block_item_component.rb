module TaoEditor
  module Components
    module ToolbarItems
      class BlockItemComponent < Base

        def initialize view, options = {}
          super
          if @options[:block_attrs].present? && @options[:block_attrs].is_a?(Hash)
            @options[:block_attrs] = @options[:block_attrs].to_json
          end
        end

        def self.component_name
          :editor_toolbar_block_item
        end

        private

        def default_options
          merge_options super, {
            class: 'tao-editor-toolbar-block-item'
          }
        end
      end
    end
  end
end
