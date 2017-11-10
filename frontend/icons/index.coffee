# import all icons
req = require.context('./', true, /\.svg$/)
req.keys().forEach(req)
