window.addEventListener('DOMContentLoaded', function () {
  let editor = ace.edit('editor', {
    mode: 'ace/mode/blade',
    navigateWithinSoftTabs: true,
    enableAutoIndent: true,
    highlightSelectedWord: true,
    scrollPastEnd: 0.1,
  });

  editor.setTheme('ace/theme/github_light_default');
  editor.setKeyboardHandler('ace/keyboard/vscode');
  editor.getSession()?.setUseSoftTabs(true)
  editor.getSession()?.setTabSize(2)

  /* ace.config.loadModule("ace/ext/keybinding_menu", function(module) {
      module.init(editor);
      editor.showKeyboardShortcuts()
  }) */

  // disable the default settings command which will call a non-existing file. 
  editor.commands.addCommand({
    name: '...',
    bindKey: {win: 'Ctrl-,',  mac: 'Command-,'},
    exec: function(editor) {},
    readOnly: true, // false if this command should not apply in readOnly mode
  });

  if (DEFAULT_CODE.length > 0) {
    editor.getSession()?.setValue(DEFAULT_CODE, -1)
  }

  let output = document.getElementById('output')
  let cli = document.getElementById('cli')
  let demo = document.getElementById('demo')

  if (output) {
    document.getElementById('run')?.addEventListener('click', async function () {
      try {
        const response = await (await fetch('/run', {
          method: 'POST',
          body: JSON.stringify({
            code: editor.getSession()?.getValue() || '',
            cli: cli?.value?.toString() || null,
          })
        })).json()

        if (!response.error) {
          output.innerText = response.data
        } else {
          alert(response.error)
        }
      } catch (e) {
        // show error...
        alert(`Playground Error: ${e.message}`)
      }
    })

    demo?.addEventListener('change', async function () {
      if (demo.value.length > 0) {
        try {
          let text = await (await fetch(`/assets/demos/${demo.value}`)).text()
          if (text) {
            editor.getSession()?.setValue(text, -1)
          }
        } catch (e) {
          alert('Network or server error. Try again')
        }
      } else if (DEFAULT_CODE) {
        editor.getSession()?.setValue(DEFAULT_CODE, -1)
      }
    })
  }
})
