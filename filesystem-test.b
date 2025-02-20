import os

os.create_dir('/workspace/temp/wrong/fable/')
os.change_dir('/workspace/temp/wrong')
echo os.cwd()
echo os.real_path('.')
echo os.real_path('./')
echo os.real_path('././././././././././././')
echo os.real_path('././././././././././././test')
echo os.real_path('../')
echo os.real_path('../../../')
echo os.real_path('../../../temp')
echo os.real_path('/workspace/temp/../')
echo os.real_path('/workspace/temp/../../')
echo os.real_path('/workspace/temp/../../../')
echo os.real_path('/workspace/temp/../../../temp')
echo os.real_path('fable')
echo os.real_path('fable/unicorn.b')
echo os.real_path('test')
echo os.real_path('test/unicorn.b')

file('/workspace/temp/wrong/fable/unicorn.b', 'w').write('hello')

echo os.real_path('fable/unicorn.b')
echo os.real_path('./fable/unicorn.b')
echo os.real_path('../fable/unicorn.b')

os.change_dir('/workspace/temp')
echo os.real_path('./fable/unicorn.b')
echo os.dir_name(
  os.abs_path('./wrong/fable/unicorn.b')
)

echo file('./wrong/fable/unicorn.b').read()

os.change_dir('/workspace/temp/wrong')

echo file('fable/unicorn.b').read()
echo file('fable/unicorn.b').exists()
echo file('fable/unicorn.b').rename('unicorn.b')

catch {
  echo file('fable/unicorn.b').stats()
} as err

if err {
  echo 'Error: ' + err.message 
}

echo file('./unicorn.b').read()
echo file('fable/unicorn.b').delete()

echo file('fable/unicorn.b').exists()
echo file('./unicorn.b').exists()
echo os.real_path('./unicorn.b')
echo os.real_path('unicorn.b')


echo file('./unicorn.b').copy('./horses.b')
echo os.read_dir(os.cwd())

echo file('./horses.b').path()
echo file('./horses.b').abs_path()
echo file('./horses.b').truncate(3)
echo file('./horses.b').read()
