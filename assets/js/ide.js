window.addEventListener('DOMContentLoaded', function() {
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

  if(DEFAULT_CODE.length > 0) {
    editor.getSession()?.setValue(decodeURIComponent(DEFAULT_CODE), -1)
  }

  let output = document.getElementById('output')
  let input = document.getElementById('input')
  let cli = document.getElementById('cli')
  let demo = document.getElementById('demo')

  if(output) {
    document.getElementById('run')?.addEventListener('click', async function() {
      try {
        const response = await (await fetch('/run', {
          method: 'POST',
          body: JSON.stringify({
            code: editor.getSession()?.getValue() || '',
            input: input?.value?.toString() || null,
            cli: cli?.value?.toString() || null,
          })
        })).json()
  
        if(!response.error) {
          output.innerText = decodeURIComponent(response.data)
        } else {
          alert(response.error)
        }
      } catch(e) {
        // show error...
        output.innerText = response.error
      }
    })

    demo?.addEventListener('change', async function () {
      if(demo.value.length > 0) {
        try {
          let text = await (await fetch(`/assets/demos/${demo.value}`)).text()
          if(text) {
            editor.getSession()?.setValue(text, -1)
          }
        } catch(e) {
          // do nothing...
        }
      }
    })
  }
})
