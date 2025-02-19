import os

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
