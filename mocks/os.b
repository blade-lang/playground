<<<===
def exec(cmd) {
  return _os.exec(cmd)
}
======
def exec(cmd) {
  return 'Executed!'
}
===>>>

<<<===
def sleep(duration) {
  _os.sleep(duration)
}
======
def sleep(duration) {
  # do nothing...
}
===>>>

<<<===
def info() {
  return _os.info()
}
======
def info() {
  return {
    sysname: 'Darwin', 
    nodename: 'MacBook-Pro.local', 
    version: 'Darwin Kernel Version 21.1.0: Wed Oct 13 17:33:24 PDT 2021; root:xnu-8019.41.5~1/RELEASE_ARM64_T8101', 
    release: '21.1.0', 
    machine: 'x86_64'
  }
}
===>>>

<<<===
    recursive = false
  }
  return _os.removedir(path, recursive)
======
    recursive = false
  }

  if !real_path(path).starts_with(cwd()) {
    raise Exception('Permission denied by Playground')
  }

  return _os.removedir(path, recursive)
===>>>
