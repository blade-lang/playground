import http
import json
import hash
import os
import thread

import dotenv.config

import ..setup {
  copy_directory
}

var sandbox_root = os.get_env('SANDBOX_ROOT')
var exe_path = os.real_path(
  os.join_paths(
    os.get_env('SANBOX_RUNTIME_DIR'),
    'blade' + (os.platform == 'windows' ? '.exe' : '')
  )
)
var BASE_URL = os.get_env('BASE_URL')

# initialize base root directory for all program execution
var base_root = os.real_path(os.join_paths(sandbox_root, 'tmp'))
if(!os.dir_exists(base_root)) {
  os.create_dir(base_root)
}

var src_dir = os.cwd()

def compile(data, project) {
  # initialize program execution root directory.
  var root = os.join_paths(base_root, project)
  if !os.dir_exists(root) {
    os.create_dir(root)

    # copy the libs directory there
    copy_directory(
      os.join_paths(os.dir_name(__root__), 'lib'),
      root
    )
  }

  var code_path = os.join_paths(root, 'code.b')
  var index_path = os.join_paths(root, 'index.b')

  var result = ''
  catch {
    file(code_path, 'w').write(data.code)

    # change working directory
    os.change_dir(root)

    # generate command
    var cmd = '"${exe_path}" "${index_path}"'
    if data.input {
      # cmd += ' <<---HEREDOC---\n' + 
      # # ensure we do not interpret interpolations at shell level
      #   data.input.replace('$', '\\$') +
      # '\n---HEREDOC---'
      cmd = 'echo -e "'+ 
        data.input.replace('\n', '\\n').replace('\r', '\\r').replace('"', '\\"') +
      '" | ${cmd}'
    }

    # redirect stderr to stdout
    cmd += ' 2>&1'

    # execute command
    result = (os.exec(cmd) or '').rtrim('\0')
  } as error 

  if error {
    echo error.message
    echo error.stacktrace
  }

  # change back to the main directory
  os.change_dir(src_dir)

  return result.trim()
}

var server = http.server(3000)

server.serve_files('/assets/', './assets')

server.handle('GET', '/p/', @(req, res) {
  var session_id = req.path[3,]
  var session_file = file(os.join_paths(base_root, session_id, 'code.b'))

  var code = '""'
  catch {
    if session_file.exists() {
      code = json.encode(session_file.read())
    }
  }

  res.render('ide', { code })
})

server.handle('GET', '/', @(req, res) {
  res.redirect('/p/' + hash.md5('${microtime()}.${rand()}'))
})

server.handle('POST', '/run', @(req, res) {
  catch {
    var referer = req.headers.get('referer')
    if !referer.starts_with(BASE_URL + '/p/') {
      res.json({ error: 'Unauthorized' })
      return
    }

    var session_id = referer[BASE_URL.length() + 3,]
    var data = json.decode(req.body.to_string())

    res.json({
      data: data.code ? compile(data, session_id) : ''
    })
  } as error

  if error {
    res.json({ error: error.message })
  }
})

server.on_error(@(err, _) {
  echo err.message
  echo err.stacktrace
})

server.listen()
