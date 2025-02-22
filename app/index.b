import http
import json
import hash
import os
import markdown
import thread

import dotenv.config

import .utils {
  get_file_list,
  copy_directory
}

# ----------- PREP SECTION STARTS --------------

var sandbox_root = os.get_env('SANDBOX_ROOT')
var exe_path = os.real_path(
  os.join_paths(
    os.get_env('SANBOX_RUNTIME_DIR'),
    'blade' + (os.platform == 'windows' ? '.exe' : '')
  )
)
var BASE_URL = os.get_env('BASE_URL')
var MD = markdown()

# initialize base root directory for all program execution
var base_root = os.join_paths(sandbox_root, 'sandbox')
if(!os.dir_exists(base_root)) {
  os.create_dir(base_root)
}
base_root = os.real_path(base_root)

var src_dir = os.cwd()

# ------------- PREP SECTION ENDS --------------

def load_demos() {
  return get_file_list(os.join_paths(
    os.dir_name(__root__), 'assets', 'demos'
  )).map(@(fl) {
    var src = os.base_name(fl)

    return { 
      name: src.replace('/[.]b$/', '').replace('-', ' '), 
      src,
    }
  })
}

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

    var cli = ''
    if data.get('cli') {
      cli = ' '.join(
        data.cli.split('/\s+/').map(@(x) {
          # return already quoted string as is...
          if (x.starts_with('"') and x.ends_with('"')) or 
            (x.starts_with("'") and x.ends_with("'")) {
            return x
          }
  
          return json.encode(x)
        })
      )
    }

    # generate command
    var cmd = '"${exe_path}" "${index_path}"'
    if cli {
      cmd += ' ${cli}'
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

var server = http.server(to_number(os.get_env('PORT') or 16000))

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

  var read_me = MD.render(
    file(os.join_paths(os.dir_name(__root__), 'README.md')).read()
  )

  res.render('ide', { 
    code, 
    read_me,
    demos: load_demos(),
  })
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
    
    data = data.code ? compile(data, session_id) : ''
    res.json({ data })

    echo data
  } as error

  if error {
    echo error.message
    echo error.stacktrace
    res.json({ error: error.message })
  }
})

server.on_error(@(err, _) {
  echo err.message
  echo err.stacktrace
})

server.listen()
