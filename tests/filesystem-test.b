import os

os.create_dir('/workspace/temp/wrong/fable/')
os.change_dir('/workspace/temp/wrong')
echo '>>> ' + os.cwd()
echo '1. ' + os.real_path('.')
echo '2. ' + os.real_path('./')
echo '3. ' + os.real_path('././././././././././././')
echo '4. ' + os.real_path('././././././././././././test')
echo '5. ' + os.real_path('../')
echo '6. ' + os.real_path('../../../')
echo '7. ' + os.real_path('../../../temp')
echo '8. ' + os.real_path('/workspace/temp/../')
echo '9. ' + os.real_path('/workspace/temp/../../')
echo '10. ' + os.real_path('/workspace/temp/../../../')
echo '11. ' + os.real_path('/workspace/temp/../../../temp')
echo '12. ' + os.real_path('fable')
echo '13. ' + os.real_path('fable/unicorn.b')
echo '14. ' + os.real_path('test')
echo '15. ' + os.real_path('test/unicorn.b')

file('/workspace/temp/wrong/fable/unicorn.b', 'w').write('hello')

echo '16. ' + os.real_path('fable/unicorn.b')
echo '17. ' + os.real_path('./fable/unicorn.b')
echo '18. ' + os.real_path('../fable/unicorn.b')

os.change_dir('/workspace/temp')
echo '19. ' + os.real_path('./fable/unicorn.b')
echo '20. ' + os.dir_name(
  os.abs_path('./wrong/fable/unicorn.b')
)

echo '21. ' + file('./wrong/fable/unicorn.b').read()

os.change_dir('/workspace/temp/wrong')

echo '22. ' + file('fable/unicorn.b').read()
echo '23. ' + to_string(file('fable/unicorn.b').exists())
echo '24. ' + to_string(file('fable/unicorn.b').rename('unicorn.b'))

catch {
  echo '25. ' + to_string(file('fable/unicorn.b').stats())
} as err

if err {
  echo 'Error: ' + err.message 
}

echo '26. ' + file('./unicorn.b').read()
echo '27. ' + to_string(file('fable/unicorn.b').delete())

echo '28. ' + to_string(file('fable/unicorn.b').exists())
echo '29. ' + to_string(file('./unicorn.b').exists())
echo '30. ' + os.real_path('./unicorn.b')
echo '31. ' + os.real_path('unicorn.b')


echo '32. ' + to_string(file('./unicorn.b').copy('./horses.b'))
echo '33. ' + to_string(os.read_dir(os.cwd()))

echo '34. ' + file('./horses.b').path()
echo '35. ' + file('./horses.b').abs_path()
echo '36. ' + to_string(file('./horses.b').truncate(3))
echo '37. ' + file('./horses.b').read()


echo '>>> ' + os.cwd()

import zip

echo '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<'
echo os.abs_path('../fable.zip')
echo '38. ' + to_string(os.read_dir('/workspace/temp/wrong'))
echo '39. ' + to_string(zip.compress('/workspace/temp/wrong', '../fable.zip', true))
echo '40. ' + to_string(os.read_dir('../'))
echo '41. ' + to_string(file('../fable.zip', 'rb').read())
echo '42. ' + to_string(zip.extract('../fable.zip', '../manner', true))
echo '43. ' + to_string(____FILESYSTEM____)
echo '44. ' + to_string(os.read_dir('../'))
echo '45. ' + to_string(os.read_dir('../manner'))
