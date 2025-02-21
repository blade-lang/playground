/**
 * @module os
 * 
 * This module provides functions for interfacing with the underlying operating system and directories.
 * 
 * @copyright 2021, Ore Richard Muyiwa and Blade contributors
 */

import _os

/**
 * The name of the current platform in string or `unknown` if 
 * the platform name could not be determined.
 * @type string
 * 
 * Example,
 * 
 * ```blade-repl
 * %> import os
 * %> os.platform
 * 'osx'
 * ```
 */
var platform = _os.platform

/**
 * A list containing the command line arguments passed to the startup script.
 * @type list
 */
var args = _os.args

/**
 * The standard path separator for the current operating system.
 * @type string
 */
var path_separator = '/'

/**
 * The full path to the running Blade executable.
 * @type string
 */
var exe_path = _os.exe_path

# File types
/**
 * Unknown file type
 * @type number
 */
var DT_UNKNOWN = _os.DT_UNKNOWN  # unknown

/**
 * Block device file type
 * @type number
 */
var DT_BLK = _os.DT_BLK  # block device

/**
 * Character device file type
 * @type number
 */
var DT_CHR = _os.DT_CHR  # character device

/**
 * Directory file type
 * @type number
 */
var DT_DIR = _os.DT_DIR  # directory

/**
 * Named pipe file type
 * @type number
 */
var DT_FIFO = _os.DT_FIFO  # named pipe

/**
 * Symbolic link file type
 * @type number
 */
var DT_LNK = _os.DT_LNK  # symbolic link

/**
 * Regular file type
 * @type number
 */
var DT_REG = _os.DT_REG  # regular file

/**
 * Local-domain socket file type
 * @type number
 */
var DT_SOCK = _os.DT_SOCK  # local-domain socket

/**
 * Whiteout file type (only meaningful on UNIX and some unofficial Linux versions).
 * @type number
 * @note value is `-1` on systems where it is not supported.
 */
var DT_WHT = _os.DT_WHT  


/**
 * Executes the given shell (or command prompt for Windows) commands and 
 * returns the output as string.
 * 
 * Example,
 * 
 * ```blade-repl
 * %> os.exec('ls -l')
 * 'total 48
 * -rw-r--r--@ 1 username  staff  705 Aug 27  2021 buggy.b
 * -rw-r--r--  1 username  staff  197 Mar  5 05:13 myprogram.b'
 * ```
 * 
 * @param string cmd
 * @returns string
 */
def exec(cmd) {
  return 'Executed!'
}

/**
 * Returns information about the current operation system and machine as a dictionary.
 * The returned dictionary will contain:
 * 
 * - `sysname`: The name of the operating system
 * - `nodename` The name of the current machine
 * - `version`: The operating system version
 * - `release`: The release level/version
 * - `machine`: The hardware/processor type.
 * 
 * Example,
 * 
 * ```blade-repl
 * %> os.info()
 * {sysname: Darwin, nodename: MacBook-Pro.local, version: Darwin Kernel Version 
 * 21.1.0: Wed Oct 13 17:33:24 PDT 2021; root:xnu-8019.41.5~1/RELEASE_ARM64_T8101, 
 * release: 21.1.0, machine: arm64}
 * ```
 * 
 * @returns dict
 */
def info() {
  return {
    sysname: 'Darwin', 
    nodename: 'MacBook-Pro.local', 
    version: 'Darwin Kernel Version 21.1.0: Wed Oct 13 17:33:24 PDT 2021; root:xnu-8019.41.5~1/RELEASE_ARM64_T8101', 
    release: '21.1.0', 
    machine: 'x86_64'
  }
}

/**
 * Causes the current thread to sleep for the specified number of seconds.
 * 
 * @param number duration
 */
def sleep(duration) {
  # do nothing...
}

/**
 * Returns the given environment variable if exists or nil otherwise
 * @returns string
 * 
 * Example,
 * 
 * ```blade-repl
 * %> import os
 * %> os.get_env('ENV1')
 * '20'
 * ```
 * 
 * @param string name
 * @returns string|nil
 */
def get_env(name) {
  return ____ENVIRONMENT____.get(name)
}

/**
 * Sets the named environment variable to the given value.
 * 
 * Example,
 * 
 * ```blade-repl
 * %> os.set_env('ENV1', 'New value')
 * true
 * %> os.get_env('ENV1')
 * 'New value'
 * ```
 * 
 * If you are in the REPL and have tried the last example in `get_env()`, 
 * you may notice that the value of `ENV1` doesn't change. This is because 
 * unless you specify, `set_env()` will not overwrite existing environment variables. 
 * For that, you will need to specify `true` as the third parameter to `set_env()`.
 * 
 * For example,
 * 
 * ```blade-repl
 * %> os.set_env('ENV1', 'New value again', true)
 * true
 * %> os.get_env('ENV1')
 * 'New value again'
 * ```
 * 
 * @note Environment variables set will not persist after application exists.
 * @param string name
 * @param string value
 * @param bool? overwrite: Default value is `false`.
 * @returns bool
 */
def set_env(name, value, overwrite) {
  if overwrite == nil overwrite = false
  if overwrite {
    ____ENVIRONMENT____.set(name, value)
  } else if !____ENVIRONMENT____.get(name) {
    ____ENVIRONMENT____.set(name, value)
  } else {
    return false
  }

  return true
}

/**
 * Creates the given directory with the specified permission and optionally
 * add new files into it if any is given.
 * 
 * @note if the directory already exists, it returns `false` otherwise, it returns `true`.
 * @note permission should be given as octal number.
 * @param string path
 * @param number? permission: Default value is `0c777`
 * @param bool? recursive: Default value is `true`.
 * @returns boolean
 */
def create_dir(path, permission, recursive) {

  if path {
    if !is_string(path) raise Exception('path must be string')
    path = path
  }
  if !path.ends_with(path_separator)
    path += path_separator

  if platform == 'windows' {
    path = path.replace('@\/@', '\\')
  }

  if permission {
    if !is_number(permission)
      raise Exception('expected number in first argument, ${typeof(permission)} given')
  } else {
    permission = 0c777
  }

  if recursive != nil {
    if !is_bool(recursive) 
      raise Exception('boolean expected in second argument, ${typeof(recursive)} given')
  } else {
    recursive = true
  }

  
  var path_split = path.rtrim("/").split('/')
  iter var i = 1; i <= path_split.length(); i++ {
    var current_path = '/'.join(path_split[,i])
    if current_path.length() > 0 and !____FILESYSTEM____.get(current_path) {
      if !recursive {
        raise Exception('No such file or directory')
      }

      ____FILESYSTEM____.set(current_path, true)
    }
  }

  return true
}

/**
 * Scans the given directory and returns a list of all matched files
 * @returns list[string]
 * 
 * Example,
 * 
 * ```blade-repl
 * %> os.read_dir('./tests')
 * [., .., myprogram.b, single_thread.b, test.b, buggy.b]
 * ```
 * 
 * @note `.` indicates current directory and can be used as argument to _os.path_ as well.
 * @note `..` indicates parent directory and can be used as argument to _os.path_ as well.
 * @param string path
 * @returns List[string]
 */
def read_dir(path) {
  path = real_path(path)
  var this_path = ____FILESYSTEM____.get(path)
  
  if !this_path {
    raise Exception('No such file or directory')
  } else if this_path != true and this_path != 0x10 {
    raise Exception('No such directory')
  }
  
  return ____FILESYSTEM____.keys().filter(@(x) {
    return x.starts_with(path)
  }).map(@(x) {
    return x[path.length(),].trim("/").split('/').first() or '.'
  }).unique()
}

/**
 * Changes the permission set on a directory to the given mode. It is advisable 
 * to set the mode with an octal number (e.g. 0c777) as this is consistent with 
 * operating system values.
 * 
 * @param string path
 * @param number mode
 * @returns boolean
 */
def chmod(path, mode) {
  if !____FILESYSTEM____.get(real_path(path)) {
    raise Exception('No such file or directory')
  }
  
  return true
}

/**
 * Returns `true` if the path is a directory or `false` otherwise.
 * 
 * @param string path
 * @returns bool
 */
def is_dir(path) {
  var tmp = ____FILESYSTEM____.get(real_path(path))
  return tmp == true or tmp == 0x10
}

/**
 * Deletes a non-empty directory. If recursive is `true`, non-empty directories 
 * will have their contents deleted first.
 * 
 * @param string path
 * @param bool recursive: Default value is `false`.
 * @returns bool
 */
def remove_dir(path, recursive) {
  if recursive != nil {
    if !is_bool(recursive)
      raise Exception('boolean expected in argument 2')
  } else {
    recursive = false
  }

  path = _real_path(path, true)
  var this_path = ____FILESYSTEM____.get(path)
  if !this_path or !(this_path == true or this_path == 0x10) {
    return false
  }

  for key, value in ____FILESYSTEM____ {
    if key.starts_with(path) {
      if recursive or (value != true and value != 0x10 and dir_name(key) == path) {
        ____FILESYSTEM____.remove(key)
      }
    }
  }

  return true
}

/**
 * Returns the current working directory.
 * 
 * @returns string
 */
def cwd() {
  for key, value in ____FILESYSTEM____ {
    if value == 0x10 {
      return key
    }
  }
  
  return '/'
}

/**
 * Navigates the working directory into the specified path.
 * 
 * @param string path
 * @returns bool
 */
def change_dir(path) {
  path = _real_path(path, true)

  if ____FILESYSTEM____.contains(path) and ____FILESYSTEM____.get(path) == true {
    for key, value in ____FILESYSTEM____ {
      if value == 0x10 or value == true {
        ____FILESYSTEM____.set(key, true)
      }
    }

    ____FILESYSTEM____.set(path, 0x10)
  }

  # don't return false if you are already in the current directory
  return ____FILESYSTEM____.get(path) == 0x10
}

/**
 * Returns `true` if the directory exists or `false` otherwise.
 * 
 * @param string path
 * @returns bool
 */
def dir_exists(path) {
  var record = ____FILESYSTEM____.get(_real_path(path, true))
  return record == true or record == 0x10
}

/**
 * Exit the current process and quits the Blade runtime.
 * 
 * @param number code
 * @returns
 */
def exit(code) {
  _os.exit(code)
}

/**
 * Concatenates the given paths together into a format that is valid on the
 * current operating system.
 * 
 * Example,
 * 
 * ```blade-repl
 * %> os.join_paths('/home/user', 'path/to/myfile.ext')
 * '/home/user/path/to/myfile.ext'
 * ```
 * 
 * @param string... paths
 * @returns string
 */
def join_paths(...) {
  var result = ''
  for arg in __args__ {
    if !is_string(arg)
      raise Exception('string expected, ${typeof(arg)} given')

    arg = arg.trim()
    
    if arg {
      result = result.rtrim(path_separator)
      if result != '' arg = arg.ltrim(path_separator)
      
      result += '${path_separator}${arg}'
    }
  }
  
  if result result = result[1,]
  
  return result
}

def _real_path(path, as_is) {
  # if path was originally empty, return as is
  if path == '' {
    return path
  }
  
  # singlefy //s to / first else, we'll end up converting .// to /.
  path = path.replace('~[\/]{2,}~', '/').
      # replace ././ series with nothing...
      replace('~(?<![.])[.]\/~', '')

  # if path is now empty or dot, return cwd
  if path == '' or path == '.' {
    return cwd()
  }
  
  var current_dir = cwd()
  var path_clone = path[,]
  
  def choose_result(result) {
    if as_is or ____FILESYSTEM____.contains(result) {
      return result.rtrim('/')
    } else {
      return path_clone
    }
  }
  
  # correct empty .. without a / at the end of a string
  if path_clone.ends_with('..') {
    path_clone += '/' 
  }
  
  if path_clone.index_of('../') == -1 {
    # path does not contain any navigation
    
    if path_clone.starts_with('/') {
      return path_clone
    } else {
      return choose_result(current_dir + '/' + path_clone)
    }
  }
  
  var root_path_split = current_dir.rtrim("/").split('/', false)
  var path_split = path_clone.split('../', false)
  if path_split.first() == '' and path_split.last() == '' {
    path_split.pop()
  }
  
  def navigate(base, root) {
    var root_is_empty = false
    
    for p in base {
      p = p.rtrim('/')
      
      if p == '' {
        root.pop()
        
        if root.length() == 0 {
          # ensure we do not navigate out of the root path
          root.append('')
          
          # but let us still be aware that root is already empty
          root_is_empty = true
        }
      } else if root.last() == p {
        # do nothing
      } else {
        # if root is already empty, return path as is
        if root_is_empty {
          return path_clone
        }
      
        if p.index_of('/') == -1 {
          root.append(p)
        } else {
          var nav_result = navigate(p.split('/', false), root)
          if nav_result {
            return nav_result
          }
        }
      }
    }
    
    return nil
  }
  
  # if the path doesn't start with ../, we have to first navigate the path_split internally
  if path_split.first() != '' {
    var splitter = path_split[1,]
    path_split = path_split.first().rtrim("/").split('/', false)
    
    navigate(splitter, path_split)
    
    # if the entire navigation has happened within path_split itself without,
    # all we have to do now is find path_split within root_path directly
    if path_split.index_of('', 1) == -1 {
      var check_length = path_split.length()
      iter var i = 0; i < check_length; i++ {
        if i > root_path_split.length() - 1 {
          break
        }

        if path_split[i] != root_path_split[i] {
          return path_clone
        }
      }
      
      # path_split is a subset of root_path
      return choose_result("/".join(path_split) or '/')
    }
  }
  
  var nav_result = navigate(path_split, root_path_split)
  if nav_result {
    return nav_result
  }
  
  return choose_result("/".join(root_path_split) or '/')
}

/**
 * Returns the original path to a relative path.
 * 
 * @note if the path is a file, see `abs_path()`.
 * @param string path
 * @returns string
 */
def real_path(path) {
  if !is_string(path)
    raise Exception('string expected, ${typeof(path)} given')
    
  return _real_path(path, false)
}

/**
 * Returns the original path to a relative path.
 * 
 * @note unlike real_path(), this function returns full path for a file.
 * @param string path
 * @returns string
 */
def abs_path(path) {

  # Return early if we already have an absolute path.
  var regex = platform == 'windows' ? '~^[a-zA-Z]\\:~' : '~^\\/~'
  if path.match(regex)
    return path

  var p = _real_path(path, true)
  if p == path {
    var np = _real_path('.', true)

    if np != path {
      p = join_paths(np, p)
    }
  }

  return p
}

/**
 * Returns the parent directory of the pathname pointed to by `path`.  Any trailing
 * `/` characters are not counted as part of the directory name.  If `path` is an
 * empty string, or contains no `/` characters, dir_name() returns the string ".", 
 * signifying the current directory.
 * 
 * @param string path
 * @returns string
 */
def dir_name(path) {
  return _os.dirname(path)
} 

/**
 * The base_name() function returns the last component from the pathname pointed to by 
 * `path`, deleting any trailing `/` characters.  If path consists entirely of `/` 
 * characters, the string '/' is returned.  If path is an empty string, the string '.' 
 * is returned.
 * 
 * @param string path
 * @returns string
 */
def base_name(path) {
  return _os.basename(path)
}
