import os
import enum
import dotenv.config

import .app.utils {
  get_file_list,
  copy_directory
}

var Config = enum({
  RuntimeDir: os.get_env('SANBOX_RUNTIME_DIR') or './runtime',
  MockDir: os.join_paths(os.dir_name(__file__), 'mocks'),
})

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
