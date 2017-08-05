module TaoEditor
  module Components
    class EditorComponent < TaoForm::Components::FieldComponent

      attr_reader :toolbar_options

      def initialize view, builder = nil, attribute_name = nil, options = {}
        super
        init_toolbar_options
      end

      def render &block
        view.content_tag tag_name, html_options do
          if block_given?
            view.concat yield
          else
            view.concat builder.hidden_field(attribute_name, class: 'editor-field')
          end
          view.concat(render_toolbar) if @options[:toolbar].present?
        end
      end

      def self.component_name
        :editor
      end

      def render_toolbar
        ToolbarComponent.new(view, toolbar_options).render
      end

      private

      def default_options
        {
          class: 'tao-editor',
          toolbar: true,
          toolbar_floatable: true
        }
      end

      def init_toolbar_options
        @toolbar_options ||= begin
          if @options[:toolbar].is_a?(Hash)
            options = @options[:toolbar]
            @options[:toolbar] = true
          else
            options = {}
          end
          options
        end
      end

    end
  end
end
