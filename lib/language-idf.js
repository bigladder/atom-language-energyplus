// Copyright (c) 2017-2018 Big Ladder Software LLC. All rights reserved.
// See the LICENSE.md file for additional terms and conditions.

const {CompositeDisposable} = require('atom')
var CommentUtils = require('./comment-utils.coffee')

module.exports = {

  subscriptions: null,

  activate(state) {
    // Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    this.subscriptions = new CompositeDisposable()

    // Register commands that add or remove comments from EnergyPlus and Modelkit files
    this.subscriptions.add(atom.commands.add('atom-workspace', {
      'language-energyplus:toggle-energyplus-comments': () => this.toggleComments("! ")
    }))

    this.subscriptions.add(atom.commands.add('atom-workspace', {
      'language-energyplus:toggle-modelkit-comments': () => this.toggleComments("# ")
    }))

  },

  initialize (state) {
  },

  serialize () {
  },

  toggleComments: function (prefix) {
    var editor = atom.workspace.getActivePaneItem()
      // active file name
      fileName = editor.getTitle()
      // selected range : (row,column)_start - (row,column)_end
      range = editor.getSelectedBufferRange()
      // use function from comment-utils.coffee to get active file extension
      ext = CommentUtils.getExtension(fileName)

    // use function from comment-utils.coffee to add or remove comments
    CommentUtils.toggleComments(range, ext, editor, prefix)
  }
}
