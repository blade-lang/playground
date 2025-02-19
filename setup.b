import os
import enum

import dotenv.config

var Config = enum({
  RuntimeDir: os.get_env('SANBOX_RUNTIME_DIR') or './runtime',
  MockDir: os.join_paths(os.dir_name(__file__), 'mocks'),
})

def get_file_list(root_dir, main_root) {
  if !main_root {
    main_root = root_dir
  }

  if os.dir_exists(root_dir) {
    return os.read_dir(root_dir).filter(@(f) { 
      return !f.starts_with('.')
    }).reduce(@(list, file) {
      var full_path = os.join_paths(root_dir, file)
      if os.dir_exists(full_path) {
        list.extend(get_file_list(full_path, main_root))
      } else {
        list.append(full_path[main_root.length(),])
      }
      return list
    }, [])
  }

  return []
}

def copy_directory(src_dir, dest_dir) {
  for fl in  get_file_list(src_dir) {
    var src = os.join_paths(src_dir, fl)
    var dest = os.join_paths(dest_dir, fl)

    if os.dir_exists(src) {
      os.create_dir(dest)
    } else {
      # create the directory if its missing
      os.create_dir(os.dir_name(dest))

      file(src).copy(dest)
    }
  }
}

def create_virtual_env() {
  copy_directory(os.dir_name(os.exe_path), Config.RuntimeDir)
  os.chmod(
    os.join_paths(
      Config.RuntimeDir, 
      'blade' + (os.platform == 'windows' ? '.exe' : '')
    ),
    0c777
  )
}

def mock_libs() {
  /* copy_directory(
    Config.MockDir, 
    os.join_paths(os.dir_name(os.exe_path), 'libs')
  ) */

  var dest_dir = os.join_paths(Config.RuntimeDir, 'libs')

  for fl in get_file_list(Config.MockDir) {
    var src = os.join_paths(Config.MockDir, fl)
    var dest = os.join_paths(dest_dir, fl)

    if !os.dir_exists(src) and !os.dir_exists(dest) {
      var dest_file = file(dest)

      if dest_file.exists() {
        var src_content = file(src).read()
        var dest_content = dest_file.read()

        var match_data = src_content.matches('/<<<===[ ]*\r?\n(.+)\n======[ ]*\r?\n(.+)\r?\n===>>>/msU')
        if match_data {
          iter var i = 0; i < match_data[0].length(); i++ {
            var search = match_data[1][i]
            var replacement = match_data[2][i]

            # echo 'Search: ${search}'
            # echo 'Replacement: ${replacement}'

            dest_content = dest_content.replace(search, replacement, false)
          }
        }

        file(dest, 'w').write(dest_content)
      }
    }
  }
}

if __file__ == __root__ {
  create_virtual_env()
  mock_libs()
}
