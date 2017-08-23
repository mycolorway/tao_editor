module TaoEditor
  module Components
    module Toolbar
      class MenuItemComponent < BaseItemComponent

        attr_reader :items

        def initialize view, options = {}
          super
          @items = @options.delete(:items)
        end

        def render &block
          render_template find_template, &block
        end

        def render_item item_options
          type = item_options.delete(:type).to_s
          item_name = item_options.delete(:name)
          item_options = {
            title: view.t("tao_editor.components.toolbar.items.#{item_name}"),
            label: true,
            class: "#{item_name.to_s.dasherize}-item"
          }.merge(item_options)
          view.send("tao_editor_toolbar_#{type.dasherize}_item", item_options)
        end

        def render_separator
          view.content_tag 'div', nil, class: 'item-separator'
        end

        def self.component_name
          :editor_toolbar_menu_item
        end

        private

        def default_options
          merge_options super, {
            class: 'tao-editor-toolbar-menu-item'
          }
        end
      end
    end
  end
end
