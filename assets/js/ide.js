window.addEventListener('DOMContentLoaded', function() {
  let editor = ace.edit('editor', {
    mode: 'ace/mode/blade',
    navigateWithinSoftTabs: true,
    enableAutoIndent: true,
  });

  editor.setTheme('ace/theme/github_light_default');
  editor.setKeyboardHandler('ace/keyboard/vscode');
  editor.getSession()?.setUseSoftTabs(true)
  editor.getSession()?.setTabSize(2)

  if(DEFAULT_CODE.length > 0) {
    editor.getSession()?.setValue(DEFAULT_CODE, -1)
  }

  let output = document.getElementById('output')
  let input = document.getElementById('input')

  if(output) {
    document.getElementById('run')?.addEventListener('click', async function() {
      try {
        const response = await (await fetch('/run', {
          method: 'POST',
          body: JSON.stringify({
            code: editor.getSession()?.getValue() || '',
            input: input.value?.toString() || null,
          })
        })).json()
  
        if(!response.error) {
          output.innerText = response.data
        } else {
          alert(response.error)
        }
      } catch(e) {
        // show error...
        output.innerText = response.error
      }
    })
  }
})
