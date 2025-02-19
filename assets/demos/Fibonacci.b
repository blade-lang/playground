def fibonacci(n) {
  if n < 2 return n

  var i = 1, previous = 0, pprevious = 1, current

  while i <= n {
    current = pprevious + previous
    pprevious = previous
    previous = current
    i++
  }

  return current
}

echo fibonacci(60)
