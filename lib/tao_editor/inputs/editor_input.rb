module TaoEditor
  module Inputs
    class EditorInput < ::SimpleForm::Inputs::Base

      def input(wrapper_options = nil)
        merged_html_options = merge_wrapper_options(input_html_options, wrapper_options)
        merged_component_options = component_options.merge(merged_html_options)
        template.tao_editor(
          @builder, attribute_name, merged_component_options
        )
      end

      private

      def component_options
        @component_options ||= input_options.slice(:toolbar, :placeholder)
      end
    end
  end
end
