module TaoEditor
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
          hr: { type: :command, command_name: :insertHr, icon: :hr },
          alignment: { type: :menu, icon: :align_left, items: [
            { type: :align, alignment: :left, name: :align_left, icon: :align_left },
            { type: :align, alignment: :center, name: :align_center, icon: :align_center },
            { type: :align, alignment: :right, name: :align_right, icon: :align_right }
          ]},
          heading: { type: :menu, icon: :heading, items: [
            { type: :block, block_name: :heading, block_attrs: {level: 1}, name: :h1, icon: :heading_1 },
            { type: :block, block_name: :heading, block_attrs: {level: 2}, name: :h2, icon: :heading_2 },
            { type: :block, block_name: :heading, block_attrs: {level: 3}, name: :h3, icon: :heading_3 },
            { type: :block, block_name: :heading, block_attrs: {level: 4}, name: :h4, icon: :heading_4 }, '|',
            { type: :block, block_name: :paragraph, name: :text, icon: :heading }
          ]},
          table: { type: :table, icon: :table, items: [
            { type: :command, command_name: :addColumnBefore, name: :add_column_before},
            { type: :command, command_name: :addColumnAfter, name: :add_column_after},
            { type: :command, command_name: :deleteColumn, name: :delete_column}, '|',
            { type: :command, command_name: :addRowBefore, name: :add_row_before},
            { type: :command, command_name: :addRowAfter, name: :add_row_after},
            { type: :command, command_name: :deleteRow, name: :delete_row}, '|',
            { type: :command, command_name: :deleteTable, name: :delete_table}
          ]}
        }
      end

      def add_item_config config
        items_config.merge! config
      end
    end

  end
end
