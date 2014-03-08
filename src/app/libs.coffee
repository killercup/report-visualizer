# # External Libs
PATH =
  bower: 'bower_components/'

npmLibs = [
  'q'
]

bowerLibs =
  react:
    # path: "#{PATH.bower}react/react-with-addons.min.js"
    path: "src/app/react-shim.js"
    exports: null
  # d3:
  #   path: "#{PATH.bower}d3/d3.min.js"
  #   exports: 'd3'
  lodash:
    path: "#{PATH.bower}lodash/dist/lodash.min.js"
    exports: '_'
    alias: 'lodash'

module.exports = npmLibs.concat Object.keys(bowerLibs)
module.exports.npmLibs = npmLibs
module.exports.bowerLibs = bowerLibs
