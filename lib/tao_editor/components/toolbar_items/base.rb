module TaoEditor
  module Components
    module ToolbarItems
      class Base < TaoOnRails::Components::Base

        attr_reader :icon, :label, :tooltip

        def initialize view, options = {}
          super
          @icon = @options.delete(:icon)
          @label = @options.delete(:label)
          @tooltip = @options.delete(:tooltip)

          @label = @options[:title] if @label == true

          if @tooltip.present?
            @tooltip = @options[:title] if @tooltip == true
            @options.delete(:title)
          end
        end

        def render &block
          view.content_tag tag_name, html_options do
            view.concat render_item_link
            view.concat(render_tooltip) if tooltip
          end
        end

        def render_item_link
          view.link_to 'javascript:;', class: 'item-link' do
            view.concat(view.tao_icon :"editor_toolbar_item_#{icon}") if icon.present?
            view.concat(view.content_tag :span, label, class: 'item-name') if label.present?
          end
        end

        def render_tooltip
          view.tao_tooltip target_traversal: 'siblings', target_selector: '.item-link',
            direction: 'bottom-center' do
            tooltip
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
