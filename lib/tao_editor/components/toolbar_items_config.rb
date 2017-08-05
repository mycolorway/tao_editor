module TaoEditor
  module Components
    module ToolbarItemsConfig
      extend ActiveSupport::Concern

      included do
        delegate :items_config, to: :class
      end

      class_methods do
        def items_config
          @items_config ||= {
            bold: { type: :mark, icon: :bold, mark_name: :strong },
            italic: { type: :mark, icon: :italic, mark_name: :em },
            underline: { type: :mark, icon: :underline, mark_name: :u },
            ul: { type: :list, icon: :unorder_list, list_name: :bullet_list },
            ol: { type: :list, icon: :order_list, list_name: :ordered_list },
            heading: { type: :menu, icon: :heading, items: [
              { type: :block, block_name: :heading, block_attrs: {level: 1}, name: :h1 },
              { type: :block, block_name: :heading, block_attrs: {level: 2}, name: :h2 },
              { type: :block, block_name: :heading, block_attrs: {level: 3}, name: :h3 },
              { type: :block, block_name: :heading, block_attrs: {level: 4}, name: :h4 },
              { type: :block, block_name: :paragraph, class: :text, name: :text }
            ]}
          }
        end

        def add_item_config config
          items_config.merge! config
        end
      end

    end
  end
end
