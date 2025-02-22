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
  SandboxRoot: os.join_paths(os.get_env('SANDBOX_ROOT') or '.', 'sandbox'),
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
  var dest_dir = os.join_paths(Config.RuntimeDir, 'libs')

  for fl in get_file_list(Config.MockDir) {
    var src = os.join_paths(Config.MockDir, fl)
    var dest = os.join_paths(dest_dir, fl)

    if !os.dir_exists(src) and !os.dir_exists(dest) {
      file(src).copy(dest)
    }
  }
}

def update_lib_for_existing_projects() {
  if os.dir_exists(Config.SandboxRoot) {
    for fl in os.read_dir(Config.SandboxRoot).filter(@(x){
      return x != '.' and x != '..' and
        os.dir_exists(os.join_paths(Config.SandboxRoot, x))
    }) {
      var dest_dir = os.join_paths(Config.SandboxRoot, fl)
      
      copy_directory(
        os.join_paths(os.dir_name(__file__), 'lib'),
        dest_dir
      )
    }
  }
}

if __file__ == __root__ {
  create_virtual_env()
  mock_libs()
  update_lib_for_existing_projects()
}
