import _ from 'lodash'
import { Schema, Fragment } from 'prosemirror-model'
import {
  tableEditing, tableNodes, addColumnBefore, addColumnAfter, deleteColumn,
  addRowBefore, addRowAfter, deleteRow, goToNextCell, deleteTable
} from 'prosemirror-tables'
import { insertPoint } from 'prosemirror-transform'
import { TextSelection } from 'prosemirror-state'
import helpers from '../helpers'
import Commands from '../commands'

createTableNode = (schema, rowCount, colCount) ->
  cellType = schema.nodes.table_cell
  cell = cellType.createAndFill()
  cells = []
  [1..colCount].forEach -> cells.push cell

  rowType = schema.nodes.table_row
  row = rowType.create null, Fragment.from(cells)
  rows = []
  [1..rowCount].forEach -> rows.push row

  tableType = schema.nodes.table
  tableNode = tableType.create null, Fragment.from(rows)


_.extend Commands,

  addColumnBefore: addColumnBefore

  addColumnAfter: addColumnAfter

  deleteColumn: deleteColumn

  addRowBefore: addRowBefore

  addRowAfter: addRowAfter

  deleteRow: deleteRow

  deleteTable: deleteTable

  goToNextCell: goToNextCell

  insertTable: (state, dispatch, rowCount, colCount) ->
    tableType = state.schema.nodes.table
    { $cursor } = state.selection
    return false unless $cursor
    insertPos = insertPoint(state.doc, $cursor.pos, tableType)
    return false unless _.isNumber insertPos

    if dispatch
      nodes = []
      nodes.push createTableNode state.schema, rowCount, colCount
      $insertPos = state.doc.resolve insertPos
      unless $insertPos.nodeAfter
        nodes.push state.schema.nodes.paragraph.createAndFill()

      tr = state.tr.insert insertPos, Fragment.from(nodes)
      tr = tr.setSelection TextSelection.create(tr.doc, insertPos + 3)
        .scrollIntoView()
      dispatch tr

    true


export default ->

  @extendPlugins ->
    tableEditing()

  @extendSchema (schema) ->
    new Schema
      nodes: schema.spec.nodes.append tableNodes
        tableGroup: 'block'
        cellContent: 'inline*'
      marks: schema.spec.marks

  @extendKeymaps (keymaps) ->
    'Tab': helpers.chainCommands(goToNextCell(1), keymaps['Tab'])
    'Shift-Tab': helpers.chainCommands(goToNextCell(-1), keymaps['Shift-Tab'])
