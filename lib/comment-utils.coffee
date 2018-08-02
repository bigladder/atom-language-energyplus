# Copyright (c) 2017 - 2018 Big Ladder Software LLC. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

module.exports =
  toggleComments: (range, ext, editor, prefix, action) ->
    if prefix == "!"
      # case-insensitive check for EnergyPlus file extension
      if (not /idf/i.test(ext)) && (not /pxt/i.test(ext)) && (not /imf/i.test(ext))
        atom.notifications.addError('Cannot apply EnergyPlus comments to this file type', (
          dismissable: true
          icon: 'alert'
          description: 'EnergyPlus comments can be applied to files that end in IDF, IMF, or PXT.'
        ))
        return false
    else if prefix == "#"
      # case-insensitive check for Modelkit file extension
      if (not /pxt/i.test(ext)) && (not /imf/i.test(ext))
        atom.notifications.addError('Cannot apply Modelkit comments to this file type', (
          dismissable: true
          icon: 'alert'
          description: 'Modelkit comments can be applied to files that end in IMF or PXT.'
        ))
        return false
    if action == "add"
      this.addComments(ext, range, editor, prefix)
    else if action == "remove"
      this.removeComments(ext, range, editor, prefix)


  # get extension of working file
  getExtension: (fileName) ->
    # split working file name into array of strings between "."
    components = fileName.split('.')
    # return final string in array
    return components[components.length-1]

  addComments: (ext, range, editor, prefix) ->
    # move cursor to beginning of first line in Range
    editor.setCursorBufferPosition([range.getRows()[0], 0])
    # loop over lines in range
    for row in range.getRows()
      text = editor.lineTextForBufferRow(row)
      # check if line is only white space
      if /\S/.test(text)
        this.addComment(editor, prefix)
      if row != range.getRows()[range.getRows().length-1]
        editor.moveDown(1)

  removeComments: (ext, range, editor, prefix) ->
    # move cursor to beginning of first line in Range
    editor.setCursorBufferPosition([range.getRows()[0], 0])
    # loop over lines in range
    for row in range.getRows()
      text = editor.lineTextForBufferRow(row)
      if this.isCommented(text, ext, range, prefix)
        this.removeComment(text, editor, prefix)
      if row != range.getRows()[range.getRows().length-1]
        editor.moveDown(1)

  # check if comment character already exists
  isCommented: (text, ext, range, prefix) ->
    # get character length of comment prefix
    prefixLength = prefix.length
    commentStartMatch = false
    # check if first character in selected text line matches comment prefix
    commentStartMatch = (text.trim().substr(0, prefixLength) == prefix)
    return commentStartMatch

  # remove first comment character in line
  removeComment: (text, editor, prefix) ->
    # strip first comment character from selected text line
    strippedText = text.replace ///#{prefix}{1}///, ""
    # select full line of text
    editor.moveToBeginningOfLine()
    editor.selectToEndOfLine()
    # pass selected text line to range
    range = editor.getSelectedBufferRange()
    # set text in range to strippedText
    editor.setTextInBufferRange(range, strippedText)

  # add comment character at start of line
  addComment: (editor, prefix) ->
    editor.moveToBeginningOfLine()
    # insert comment character at beginning of text line
    editor.insertText(prefix)
