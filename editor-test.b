/**
 * A doc block here...
 * 
 * @param {string} name
 */
def main(name) {

  class Game  {
    Game() {}

    init() {
      self.cval = __file__
    }

    @to_string() {
      return 1000 >>> 0
    }
  }

  # A line comment

  var crazy = 'Got it working!'
  var numeric = 1.5E-10

  Game().to_string()
}

echo 'it works'

