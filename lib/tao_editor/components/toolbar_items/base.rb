module TaoEditor
  module Components
    module ToolbarItems
      class Base < TaoOnRails::Components::Base

        attr_reader :icon

        def initialize view, options = {}
          super
          @icon = @options.delete(:icon)
        end

        def render &block
          view.content_tag tag_name, html_options do
            view.tao_icon :"editor_toolbar_item_#{icon}"
          end
        end

        private

        def default_options
          {class: 'tao-editor-toolbar-item'}
        end
      end
    end
  end
end
