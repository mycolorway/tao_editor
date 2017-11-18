import '@mycolorway/tao/frontend/javascripts/custom_elements'
import { expect } from 'chai'
import $ from 'jquery'
import { Component } from '@mycolorway/tao'
import EditorElement from '../javascripts/element'

describe 'Tao Editor', ->

  element = null

  beforeEach (done) ->
    element = $('''
      <tao-editor>
        <input type="hidden" />
      </tao-editor>
    ''').appendTo('body').get(0)
    setTimeout -> done()

  afterEach ->
    element.jq.remove()
    element = null

  it 'inherits from TaoComponent', ->
    expect(element instanceof Component).to.be.true
    expect(element instanceof EditorElement).to.be.true
