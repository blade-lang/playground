import reflect

# create virtual filesystem
# 
# - files have a structure
# - directories are true or 0x10
# - only the current directory is 0x10
reflect.set_global({
  '/': true,
  '/workspace/': 0x10,
}, '____FILESYSTEM____')

# create virtual environment
reflect.set_global({}, '____ENVIRONMENT____')

import .file
import .code {*}
