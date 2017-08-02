module TaoEditor
  module Components
    class ToolbarComponent < TaoOnRails::Components::Base

      include TaoEditor::Components::ToolbarItemsConfig

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
            if item == '|'
              view.concat render_separator
            else
              view.concat render_item item
            end
          end
        end
      end

      def render_item item_name
        item_options = items_config[item_name].clone
        return unless item_options.present?
        type = item_options.delete(:type)
        item_class = "TaoEditor::Components::ToolbarItems::#{type.capitalize}ItemComponent".constantize
        item_class.new(view, item_options).render
      end

      def render_separator
        view.content_tag 'div', nil, class: 'item-separator'
      end

      private

      def default_options
        {
          class: 'tao-editor-toolbar',
          floatable: true,
          items: ['bold', 'italic', 'underline', '|', 'unorder_list', 'order_list']
        }
      end

    end
  end
end
