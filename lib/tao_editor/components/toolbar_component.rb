module TaoEditor
  module Components
    class ToolbarComponent < TaoOnRails::Components::Base

      include TaoEditor::ToolbarItemsConfig

      attr_reader :items

      def initialize view, options = {}
        super
        @items = @options.delete(:items)
      end

      def self.component_name
        :editor_toolbar
      end

      def render &block
        view.content_tag tag_name, html_options do
          items.map(&:to_sym).each do |item|
            if item == :'|'
              view.concat render_separator
            else
              view.concat render_item item
            end
          end
        end
      end

      def render_item item_name
        item_options = get_item_options item_name
        return unless item_options.present?

        type = item_options.delete(:type)
        component = if type
          "tao_editor_toolbar_#{type.to_s.dasherize}_item"
        else
          item_options.delete(:component)
        end
        view.send(component, item_options)
      end

      def render_separator
        view.content_tag 'div', nil, class: 'item-separator'
      end

      private

      def default_options
        {
          class: 'tao-editor-toolbar',
          items: ['heading', 'bold', 'italic', 'underline', 'alignment', '|', 'ul', 'ol', 'table', 'hr']
        }
      end

      def get_item_options item_name
        item_options = items_config[item_name]
        return unless item_options.present?
        {
          title: view.t("tao_editor.components.toolbar.items.#{item_name}"),
          tooltip: true,
          class: "#{item_name.to_s.dasherize}-item"
        }.merge(item_options)
      end

    end
  end
end
