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
            bold: { type: :mark, icon: :bold, mark: :em },
            italic: { type: :mark, icon: :italic, mark: :i },
            underline: { type: :mark, icon: :underline, mark: :u },
            unorder_list: { type: :command, icon: :unorder_list, command: :wrapInUnorderList },
            order_list: { type: :command, icon: :order_list, command: :wrapInOrderList }
          }
        end

        def add_item_config (config)
          items_config.merge! config
        end
      end

    end
  end
end
